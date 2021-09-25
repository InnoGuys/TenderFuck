import syslog

from django.http import HttpResponse

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
    if not request.GET.get("customer_id") is None:
        print(request.GET.get("customer_id"))
    else:
        print(request.GET.get("customer_id"))

# elif not request.GET.get("customer_tin") is None:
    # elif not request.GET.get("customer_tin") is None:
    # elif:

    return HttpResponse("contracts")
