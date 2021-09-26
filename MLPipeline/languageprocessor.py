import string

import numpy
from transformers import AutoTokenizer, AutoModel
import torch
import pickle
from itertools import chain, combinations
import pymorphy2


# Эта функция взята из примера. Насколько я понимаю, нужна, если на вход подается цепочка из
# предложений или текстов.
# В моем случае она не очень нужна, но я не стал ее выкидывать и трогать то, что работает


# Mean Pooling - Take attention mask into account for correct averaging
def mean_pooling(model_output, attention_mask):
    token_embeddings = model_output[0]  # First element of model_output contains all token embeddings
    input_mask_expanded = attention_mask.unsqueeze(-1).expand(token_embeddings.size()).float()
    sum_embeddings = torch.sum(token_embeddings * input_mask_expanded, 1)
    sum_mask = torch.clamp(input_mask_expanded.sum(1), min=1e-9)
    return sum_embeddings / sum_mask


# Это класс, в котором происходит всякая работа с вычислениями семантики текста
class SemanticsProcessor:
    # В этом словаре хранятся предрасчитанные векторы
    # Наполнить этот словарь можно, используя функцию precalc_embeddings()
    # Наполнить и сохранить словарь можно через precalc_embeddings_saving()
    # Считать из файла в этот словарь можно через load_pickle()
    precalc = dict()

    # Если на компьютере нет скачанной модели, она загрузится из репозитория
    def __init__(self):
        # Load AutoModel from huggingface model repository
        self.tokenizer = AutoTokenizer.from_pretrained("sberbank-ai/sbert_large_nlu_ru")
        self.model = AutoModel.from_pretrained("sberbank-ai/sbert_large_nlu_ru")

    # Эта функция выдает список векторов для каждого предложения (текста) из входного списка.
    # В каждом векторе будут учитываться соседние значения. Если надо анализировать длинный текст,
    # лучше работать с этой функцией, потому что тогда при обработке каждого элемента списка будет
    # учитываться контекст остальных элементов
    def get_embeddings(self, sentence_list):
        # Tokenize sentences
        encoded_input = self.tokenizer(sentence_list, padding=True, truncation=True, max_length=24, return_tensors='pt')

        # Compute token embeddings
        with torch.no_grad():
            model_output = self.model(**encoded_input)

        # Perform pooling. In this case, mean pooling
        return mean_pooling(model_output, encoded_input['attention_mask'])

    # Эта функция не учитывает контекст всего списка, как предыдущая, зато при наличии в словаре сохраненки
    # для отдельного элемента списка, выдаст ее, а не будет считать заново
    def get_embeddings_precalc(self, sentence_list):
        result = []
        for sentence in sentence_list:
            result.append(self.get_embedding_precalc(sentence))[0]
        return result

    # Эта функция считает список векторов для списка текстов и сохраняет их с в словарь
    # Она тоже не учитывает контекст всего списка, потому что в сохраненках он будет мешать
    def precalc_embeddings(self, sent):
        iter = 0
        for st in sent:
            if st not in self.precalc:
                iter += 1
                self.precalc[st] = self.get_embeddings([st])[0]

    # Эта функция действует также, как и предыдущая, но в конце сохраняет полученный словарик с сохраненками в файл
    def precalc_embeddings_saving(self, sent):
        iter = 0
        for st in sent:
            print(str(iter) + "/" + str(len(sent)))
            iter += 1
            self.precalc[st] = self.get_embeddings([st])[0]
            if iter % 500 == 0:
                with open('precalc.pickle', 'wb') as handle:
                    pickle.dump(self.precalc, handle, protocol=pickle.HIGHEST_PROTOCOL)
                    print("Checkpoint saved!")

        with open('precalc.pickle', 'wb') as handle:
            pickle.dump(self.precalc, handle, protocol=pickle.HIGHEST_PROTOCOL)
            print("Checkpoint saved!")

    # Отдельная функция для вывода сохраненок в файл
    def precalc_pickle_save(self):
        with open('precalc.pickle', 'wb') as handle:
            pickle.dump(self.precalc, handle, protocol=pickle.HIGHEST_PROTOCOL)
            print("Checkpoint saved!")

    # Очистка словарика, просто так, почему бы и нет =)
    def clear_precalc_embeddings(self):
        self.precalc = {}

    # Удаляет сохраненку для каждой строки в списке, если она, конечно, есть в словаре
    def remove_precalc_embeddings(self, sent):
        for key in sent:
            if key in self.precalc:
                del self.precalc[key]

    # Наиболее нужная функция для меня. Выдает семантический вектор по одной строке
    # Ищет в сохраненках нужное, если нет, считает вектор и выдает его
    # После просчитывания, вектор НЕ попадет в сохраненки автоматически
    # (чтобы не забивать память, вдруг эта строка больше нигде никогда не встретится)
    def get_embedding_precalc(self, sentence):
        if sentence not in self.precalc:
            return (self.get_embeddings([sentence])[0])
        else:
            return (self.precalc[sentence])

    # Выдает расстояние между семантическими векторами по Пифагору (корень суммы квадратов)
    # Работает ЗНАЧИТЕЛЬНО быстрее, чем простое использование цикла с суммированием
    # квадратов из Python (слава numpy)
    def distance(self, a, b):

        td = numpy.linalg.norm(a - b)
        # dist=0
        # for i in range(len(a)):
        #    dist+=(a[i].numpy()-b[i].numpy())**2
        return td

    # На вход получает список строк (param) и еще одну строку (sent).
    # на выход выдает строку из списка param, на которую больше всего по смыслу похожа строка sent
    def choose_nearest(self, param, sent):
        a = self.get_embedding_precalc(param)
        min_dist = 9999999999999999999
        res_sent = ""
        iter = 0
        for st in sent:
            iter += 1
            # print(str(iter)+"/"+str(len(sent)))
            td = self.distance(a, self.get_embedding_precalc(st))
            if td < min_dist:
                res_sent = st
                min_dist = td
        return res_sent

    # На вход получает список строк (param) и еще одну строку (sent).
    # печатает расстояния от param до каждого из sent
    def print_distances(self, param, sent):
        a = self.get_embedding_precalc(param)
        iter = 0
        for st in sent:
            # print(str(iter)+"/"+str(len(sent)))
            td = self.distance(a, self.get_embedding_precalc(st))
            print(st + "-" + str(td) + "-" + param)

    # То же самое, но вместо param используется словарь с сохраненками
    def choose_nearest_in_precalc(self, param):
        a = self.get_embedding_precalc(param)
        min_dist = 9999999999999999999
        res_sent = ""
        iter = 0
        for st, vec in self.precalc.items():
            iter += 1
            # print(str(iter))
            td = self.distance(a, vec)
            if td < min_dist:
                res_sent = st
                min_dist = td
        return res_sent
    
    
    def choose_nearest_in_precalc_by_vector(self, param):
        a = param
        min_dist = 9999999999999999999
        res_sent = ""
        iter = 0
        for st, vec in self.precalc.items():
            iter += 1
            # print(str(iter))
            td = self.distance(a, vec.numpy())
            if td < min_dist:
                res_sent = st
                min_dist = td
        return res_sent

    # Загрузить сохраненки из файла
    def load_pickle(self):
        with open('precalc.pickle', 'rb') as handle:
            self.precalc = pickle.load(handle)

    # При входе
    # a b c
    # получится несколько массивов:
    # a, a b, a c, b, b c, c, a b c
    def powerset(self, iterable):
        s = list(iterable)
        return chain.from_iterable(combinations(s, r) for r in range(len(s) + 1))

    def sublists(self, l):
        l = list(l)
        lists = []
        for i in range(len(l) + 1):
            for j in range(i):
                lists.append(l[j: i])
        return lists

    def sublists_len(self, l, val):
        l = list(l)
        lists = []
        if len(l)+1<val:
            return []
        for i in range(len(l) + 1 - val):
                lists.append(l[i: i+val])
        return lists

    # Интересная функция. При запросе
    # phrase="Привет. Пожалуйста, расскажи про осадки в Москве" и ref="какая погода"
    # функция найдет, что "расскажи про осадки" = "какая погода", и удалит из phrase эти слова.
    # Вывод получится: "Привет. Пожалуйста, в Москве"
    # После, при помощи класса MorphologyProcessor (ниже в этом файле)
    # можно найти все имена собственные и понять,
    # что нужна погода именно в Москве
    def get_free_words(self, phrase, ref):
        ref_emb = self.get_embedding_precalc(ref)
        in_words = phrase.split()
        all_in = self.powerset(in_words)
        min_dist = 9999999999999999999
        best_phrase = ""
        for tphrase in all_in:
            sentence = " ".join(tphrase)
            dist = self.distance(self.get_embedding_precalc(sentence), ref_emb)
            if dist < min_dist:
                min_dist = dist
                best_phrase = tphrase
        tmp = [item for item in in_words if item not in best_phrase]
        answ = []
        for i in tmp:
            answ.append(i.translate(str.maketrans('', '', string.punctuation)))
        return answ

    def get_free_words_max_performance(self, phrase, ref):
        ref_emb = self.get_embedding_precalc(ref)
        in_words = phrase.split()
        all_in = self.sublists_len(in_words,len(ref.split()))
        min_dist = 9999999999999999999
        best_phrase = ""
        for tphrase in all_in:
            sentence = " ".join(tphrase)
            dist = self.distance(self.get_embedding_precalc(sentence), ref_emb)
            if dist < min_dist:
                min_dist = dist
                best_phrase = tphrase
        tmp = [item for item in in_words if item not in best_phrase]
        answ = []
        for i in tmp:
            answ.append(i.translate(str.maketrans('', '', string.punctuation)))
        return answ

    def get_free_words_performance(self, phrase, ref):
        ref_emb = self.get_embedding_precalc(ref)
        in_words = phrase.split()
        all_in = self.sublists(in_words)
        min_dist = 9999999999999999999
        best_phrase = ""
        for tphrase in all_in:
            sentence = " ".join(tphrase)
            dist = self.distance(self.get_embedding_precalc(sentence), ref_emb)
            if dist < min_dist:
                min_dist = dist
                best_phrase = tphrase
        tmp = [item for item in in_words if item not in best_phrase]
        answ = []
        for i in tmp:
            answ.append(i.translate(str.maketrans('', '', string.punctuation)))
        return answ


# Простой класс, просто обертка для библиотеки PyMorphy2.
class MorphologyProcessor:
    def __init__(self):
        self.morph = pymorphy2.MorphAnalyzer()

    # Приводит слова к онрмальной форме (победил -- победить, ручку -- ручка)
    def normal_form(self, param):
        answ = []
        for word in param:
            answ.append(self.morph.parse(word)[0].normal_form)
        return answ

    # Находит в списке list слова, которые имеют характеристику param
    # Список характеристик, которые может иметь слово, смотри здесь:
    # https://pymorphy2.readthedocs.io/en/stable/user/grammemes.html
    # В разделе "Обозначения для граммем"
    def get_words(self, param, list):
        answ = []
        for word in list:
            if param in self.morph.parse(word)[0].tag:
                answ.append(word)
        return answ
