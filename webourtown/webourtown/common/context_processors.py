from django.core.cache import get_cache

def session(request):
    if 'sessionid' in request.COOKIES :
        session_key = request.COOKIES['sessionid']
        user_session = get_cache('user_session')
        user_info = user_session.get(session_key)
        return dict(session = user_info)
    else :
        return dict()
