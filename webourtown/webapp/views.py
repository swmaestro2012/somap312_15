# -*- coding: utf-8 -*-
from django.core.cache import get_cache
from django.http import HttpResponse, Http404
from django.template import Context
from django.template.loader import get_template
from sqlalchemy import func
from webourtown.common.shortcuts import redirect, render
from webourtown.common.utils import *
from webourtown.models import Spot, Snap, SnapComment, SnapLike, User
from webourtown.orm import get_session, to_dict

import md5
import uuid
import random

def mainpage(request):
    if request.method == 'GET':
        session = get_session()
        total_num_of_spot = session.query(func.count(Spot.spot_id)).first()[0]

        #carousel
        selected_spot_id = []
        selected_spots = []
        while len(selected_spot_id) < 4:
            random_spot_id = random.randint(1, total_num_of_spot)
            if random_spot_id in selected_spot_id:
                continue
            snapcheck = session.query(Snap).filter(Snap.spot_id==random_spot_id).all()
            if len(snapcheck) < 4:
                continue

            selected_spot_id.append(random_spot_id)
            snaps = session.query(Snap).filter(Snap.spot_id==random_spot_id).limit(4).all()
            spot_info = session.query(Spot).get(random_spot_id)
            selected_spot_data = dict(
                snaps = to_dict(snaps),
                info = to_dict(spot_info),
                )
            selected_spots.append(selected_spot_data)
            
        #carousel end
        
        if 'spot' in request.GET :
            snaps = session.query(Snap).filter(Snap.spot_id==request.GET['spot']).limit(18).all()
        else :
            snaps = session.query(Snap).limit(18).all()

        spot_list = session.query(Spot).all()
        # 과거의 너의 코드
        # template = get_template('mainpage.html')
        # variables = Context({'snaps':snaps, 'userinfo':value, 'spotname_a':spotname_a, 'csnaps_a':csnaps_a, 'spotname_b':spotname_b, 'csnaps_b':csnaps_b, 'spotname_c':spotname_c, 'csnaps_c':csnaps_c})
        # output = template.render(variables)
        # return HttpResponse(output)
        # 새롭게 짜야하는 코드
        data = {
            'spot_list': spot_list,
            'snaps':snaps, 
            'selected_spots': selected_spots,
            }
        # 이렇게 짜야한다~ 예시이면서 나머지도 다 바꾼다
        return render(request, 'mainpage.html', data)
    else :
        return HttpResponse('Error')

def login(request):
    if request.method == 'GET':
        data = dict()
        if 'next' in request.GET :
            data['next'] = request.GET['next']
        return render(request, 'login.html', data)

    elif request.method == 'POST':
        session = get_session()
        m = session.query(User).filter(User.user_id==request.POST['user_id']).first()
        if m.user_password == md5.new(request.POST['user_password']).hexdigest():
            
            user_session = get_cache('user_session')
            
            key = str(uuid.uuid4())
            value = dict(
                uid=m.id,
                user_id=m.user_id,
                user_gender=m.userinfo.gender,
                user_nickname=m.userinfo.nickname,
                user_is_admin=m.userinfo.is_admin,
                )
            
            user_session.set(key,value,86400)
            
            if 'next' in request.POST :
                response = redirect(request.POST['next'])
            else :
                response = redirect('/')
            response.set_cookie('sessionid',key,86400)

            return response
        else:
            return HttpResponse('login fail!')
    else:
        return HttpResponse('Error')

def logout(request):
    if request.method == 'GET':
        user_session = get_cache('user_session')
        key = request.COOKIES['sessionid']
        
        user_session.delete(key)
        
        response = redirect('/')
        response.delete_cookie('sessionid')
        return response
    else:
        return HttpResponse('Error')

def bigpage(request, snap_id=None):
    if request.method == 'GET':
        session = get_session()
        snap = session.query(Snap).get(snap_id)

        user_session = get_cache('user_session')
        if not 'sessionid' in request.COOKIES:
            value = None
            like = None
        else :
            key = request.COOKIES['sessionid']
            value = user_session.get(key)
            like = session.query(SnapLike).filter_by(snap_id=snap_id, user_id=value['uid']).first()

        # template = get_template('bigpage.html')
        # variables = Context({'userinfo':value, 'comments':snap.comments, 'likes':snap.likes, 'image_id':snap.image_id, 'likebtn':likebtn})
        # output = template.render(variables)
        # return HttpResponse(output)        
        data = {
            'snap':snap, 
            'like':like,
            }
        return render(request, 'bigpage.html', data)

    elif request.method == 'POST':
        user_session = get_cache('user_session')
        key = request.COOKIES['sessionid']
        value = user_session.get(key)

        session = get_session()
        snap = session.query(Snap).get(snap_id)


        form_type = request.POST['form_type']

        if form_type == 'comment':            
            new_comment = request.POST['new_comment']        
            s = SnapComment(user_id = value['uid'], snap_id = snap_id, spot_id = snap.spot_id, comment = new_comment)
            try :
                session.add(s)
                session.commit()
            except :
                session.rollback()
        session.close()
        response = redirect('/bigpage/{image_id}'.format(image_id = snap.image_id))
        return response
    
    else:
        return HttpResponse('Error')
# ajax request
def post_comment(request, snap_id=None):
    if 'sessionid' not in request.COOKIES:
        result = dict(success=False, message=u'must login')
        return HttpResponse(dumps(result), content_type='application/json')
    if 'comment' not in request.POST :
        result = dict(success=False, message=u'comment is not in the request body')
        return HttpResponse(dumps(result), content_type='application/json')

    user_session = get_cache('user_session')
    user_info = user_session.get(request.COOKIES['sessionid'])

    session = get_session()
    snap = session.query(Snap).get(snap_id)
    if not snap:
        result = dict(success=False, message=u'no snap with snap id {{snap_id}}'.format(snap_id=snap_id))
        return HttpResponse(dumps(result), content_type='application/json')
    new_comment = SnapComment(snap_id=snap.snap_id, spot_id=snap.spot_id, user_id=user_info['uid'], comment=request.POST['comment'])
    try: 
        session.merge(new_comment)
        session.commit()
    except:
        session.rollback()
        result = dict(success=False, message=u'failed to save comment')
        return HttpResponse(dumps(result), content_type='application/json')
    session.close()
    result = dict(success=True, message=u'comment posted!')
    return HttpResponse(dumps(result), content_type='application/json')

# ajax request
def like_snap(request, snap_id=None):
    if 'sessionid' not in request.COOKIES:
        result = dict(success=False, message=u'must login')
        return HttpResponse(dumps(result), content_type='application/json')
    user_session = get_cache('user_session')
    user_info = user_session.get(request.COOKIES['sessionid'])

    session = get_session()
    snap = session.query(Snap).get(snap_id)
    if not snap :
        result = dict(success=False, message=u'no snap with snap id {{snap_id}}'.format(snap_id=snap_id))
        return HttpResponse(dumps(result), content_type='application/json')
    
    new_snap_like = SnapLike(snap_id=snap.snap_id, user_id=user_info['uid'], spot_id=snap.spot_id)
    try:
        session.merge(new_snap_like)
        session.commit()
    except:
        session.rollback()
        result = dict(success=False, message=u'failed to save like')
        return HttpResponse(dumps(result), content_type='application/json')
    session.close()
    result = dict(success=True, message='like!')
    return HttpResponse(dumps(result), content_type='application/json')
    
# ajax request
def unlike_snap(request, snap_id=None):
    if 'sessionid' not in request.COOKIES:
        result = dict(success=False, message=u'must login')
        return HttpResponse(dumps(result))
    user_session = get_cache('user_session')
    user_info = user_session.get(request.COOKIES['sessionid'])

    session = get_session()
    snap = session.query(Snap).get(snap_id)
    if not snap :
        result = dict(success=False, message=u'no snap with snap id {{snap_id}}'.format(snap_id=snap_id))
        return HttpResponse(dumps(result), content_type='application/json')
    
    snap_like = session.query(SnapLike).filter_by(snap_id=snap.snap_id, user_id=user_info['uid']).first()
    
    if not snap_like :
        result = dict(success=False, message=u"you didn't liked this snap")
        return HttpResponse(dumps(result), content_type='application/json')
    try:
        session.delete(snap_like)
        session.commit()
    except:
        session.rollback()
        result = dict(success=False, message=u'failed to delete like')
        return HttpResponse(dumps(result), content_type='application/json')
    session.close()
    result = dict(success=True, message='unlike!')
    return HttpResponse(dumps(result), content_type='application/json')
