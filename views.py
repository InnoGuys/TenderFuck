import syslog

from django.http import HttpResponse

from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.authtoken.models import Token

import sqlalchemy as db

import torch


# from django.shortcuts import render
#
# def index(request):
#     print('log: ' + request.get_full_path())
#     return render(request, '../templates/front/base.html')
#
#
# def detail(request):
#     request.GET.get("customer_id")
#     return HttpResponse("You're looking at question %s." % request.GET.get("customer_id")) # % customer_id

def test(request):
    return HttpResponse("STRING EXAMPLE", content_type="text/plain")

def scu(request):
    engine = db.create_engine('sqlite:///databases/scu.sqlite3')
    connection = engine.connect()
    metadata = db.MetaData()
    table = db.Table('Запрос1', metadata, autoload=True, autoload_with=engine)

    if not request.GET.get("id") is None:
        id_scu = int(request.GET.get("id"))
        print(id_scu)

        # Equivalent to 'SELECT * FROM table WHERE ID_СТЕ = <id>'
        query = db.select([table]).where(table.columns.ID_СТЕ == id_scu)
        print(table.columns.ID_СТЕ)
        ResultProxy = connection.execute(query)
        ResultSet = ResultProxy.fetchall()

        keys = table.columns.keys()

        # print(keys)

        sep = ","
        response_msg = "{"
        for a in ResultSet:
            li = list(a)
            response_msg += '"' + "id" + str(li[0]) + '"' + ":" + "{"
            for idx_b in range(len(li[:-1])):
                response_msg += '"' + str(keys[idx_b]) + '"' + ":" + '"' + (
                    str(li[idx_b]).replace('"', "'")) + '"' + sep
            response_msg += '"' + str(keys[-1]) + '"' + ":" + '"' + (
                str(li[-1]).replace('"', "'").replace(',', ';')) + '"' + sep
            response_msg = response_msg[:-len(sep)]
            response_msg += "}" + sep

        response_msg = response_msg[:-len(sep)]
        response_msg += "}"

        response_msg = response_msg.replace(" ", "")

        return HttpResponse(response_msg, content_type="application/json")

    return HttpResponse("need param 'id' like '?id=<INTEGER>'")

@api_view(['GET'])
# @permission_classes(['GET'])
def contracts(request):
    engine = db.create_engine('sqlite:///databases/contracts.sqlite3')
    connection = engine.connect()
    metadata = db.MetaData()
    table = db.Table('Запрос1', metadata, autoload=True, autoload_with=engine)

    if not request.GET.get("keys") is None:  # get keys of table
        return HttpResponse(str(table.columns.keys()))

    # if not request.GET.get("customer_id") is None:
    #     print(request.GET.get("customer_id"))
    #     return HttpResponse("contracts " + str(request.GET.get("customer_id")))
    if not request.GET.get("customer_tin") is None:

        customer_tin = int(request.GET.get("customer_tin"))
        print(customer_tin)

        # Equivalent to 'SELECT * FROM table WHERE ИННпоставщика = <customer_tin>'
        query = db.select([table]).where(table.columns.ИННзаказчика == customer_tin)
        print(table.columns.ИННпоставщика)
        ResultProxy = connection.execute(query)
        ResultSet = ResultProxy.fetchall()

        print("\nContracts end.\n")

        result = []
        statLine = 0
        endLine = 10
        if not request.GET.get("start") is None:
            start = int(request.GET.get("start"))
            if not request.GET.get("end") is None:
                end = int(request.GET.get("end"))
                if len(ResultSet) < end:
                    endLine = len(ResultSet)
                else:
                    endLine = end
            else:
                if len(ResultSet) > start > 0:
                    statLine = start
                else:
                    return HttpResponse('[]')
            result = ResultSet[statLine:endLine]

        else:
            if len(ResultSet) < 10:
                endLine = len(ResultSet)
            result = ResultSet[statLine:endLine]

        print("result: " + str(result))

        for idx in range(len(result)):
            result[idx] = list(result[idx])

        # print(json.dumps(result))
        # return HttpResponse(json.dumps(result))

        keys = table.columns.keys()

        # print(keys)

        sep = ","
        response_msg = "{"
        for a in ResultSet:
            li = list(a)
            response_msg += '"' + "id" + str(li[0]) + '"' + ":" + "{"
            for idx_b in range(len(li[:-1])):
                response_msg += '"' + str(keys[idx_b]) + '"' + ":" + '"' + (str(li[idx_b]).replace('"', "'")) + '"' + sep
            response_msg += '"' + str(keys[-1]) + '"' + ":" + '"' + (str(li[-1]).replace('"', "'").replace(',', ';')) + '"' + sep
            response_msg = response_msg[:-len(sep)]
            response_msg += "}" + sep

        response_msg = response_msg[:-len(sep)]
        response_msg += "}"

        response_msg = response_msg.replace(" ", "")

        # print("response_msg" + str(response_msg))

        return HttpResponse(response_msg, content_type="application/json")


    else:

        return ("need params as customer_tin like '?customer_tin=<INTEGER>'")
