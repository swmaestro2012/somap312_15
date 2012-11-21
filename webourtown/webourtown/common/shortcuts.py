from django.shortcuts import render as django_render, render_to_response as django_render_to_response, redirect as django_redirect

def render_to_response(*args, **kwargs):
    response = django_render_to_response(*args, **kwargs)
    session = kwargs.pop('session', None)
    if session:
        session.close()
    return response

def render(request, *args, **kwargs):
    response = django_render(request, *args, **kwargs)
    session = kwargs.pop('session', None)
    if session :
        session.close()
    return response
    

def redirect(to, *args, **kwargs):
    response = django_redirect(to, *args, **kwargs)
    session = kwargs.pop('session', None)
    if session:
        session.close()
    return response
