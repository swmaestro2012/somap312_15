from django.utils import simplejson

def dumps(obj, pretty=False) :
    try :
        if pretty :
            return simplejson.dumps(obj, sort_keys=True, indent=4)
        else :
            return simplejson.dumps(obj)
    except :
        result = dict(success=False, message=u'jsonfy error')
        return simplejson.dumps(result)

def loads(obj) :
    try :
        return simplejson.loads(obj)
    except :
        return None
