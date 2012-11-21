from django.conf.urls import patterns, include, url
from webapp.views import *
from webourtown.common.route import mapping
from webourtown.settings import STATIC_ROOT

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
                       url(r'^$', mainpage),
                       url(r'^static/(?P<path>.*)/$', 'django.views.static.serve', { 'document_root': STATIC_ROOT }),
                       url(r'^login/$',login),
                       url(r'^logout/$',logout),
                       url(r'^bigpage/(?P<snap_id>\d+)/$',bigpage),
                       mapping(r'^snap/(?P<snap_id>\d+)/comment/$', post=post_comment),
                       mapping(r'^snap/(?P<snap_id>\d+)/like/$', post=like_snap),
                       mapping(r'^snap/(?P<snap_id>\d+)/unlike/$', post=unlike_snap),
    # Examples:
    # url(r'^$', 'webourtown.views.home', name='home'),
    # url(r'^webourtown/', include('webourtown.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)
