from django.views.generic import View, TemplateView
from django.views.generic.edit import FormView
from django.utils.decorators import method_decorator
from django.forms.models import model_to_dict
from rest_framework.response import Response


from rest_framework import generics, pagination
from rest_framework.renderers import JSONRenderer

from .models import Todo
from .serializers import TodoSerializer

class TodosView(generics.ListCreateAPIView):
    queryset = Todo.objects.all();
    pagination_class = pagination.PageNumberPagination
    serializer_class = TodoSerializer

    def list(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

class TodoView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = TodoSerializer
    pagination_class = pagination.PageNumberPagination

    def get_queryset(self):
        id = self.kwargs.get('id', -1)
        if(id != -1):
            return Todo.objects.get(id=id)
        else:
            print('invalid todo id')
            return Todo()

    def get_object(self):
        return self.get_queryset()