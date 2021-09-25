import syslog

from django.http import HttpResponse

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

def scu(request):
    return HttpResponse("SCU")


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
        response_msg = '{'
        for line in result:
            response_msg = response_msg + str(line) + "\n"
        response_msg = response_msg + '}'
        # response_msg = '\n'  # '\n' is divider
        # response_msg.join(result)  # response_msg looks like 'response1\nresponse2\nresponse3'...
        print("response_msg" + str(response_msg))

        return HttpResponse(response_msg)

    else:

        return HttpResponse("need params as customer_tin like '?customer_tin=<INTEGER>'")
