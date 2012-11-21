from sqlalchemy import create_engine as sa_create_engine
from sqlalchemy.orm import sessionmaker
from settings import DATABASES
from models import *

import datetime
import StringIO
import PIL.Image

LIMIT = 20
OFFSET = 0

# num_of_sessions = 4
# sessions = [ None for x in range(num_of_sessions) ]
# session_index = 0
session = None

def get_session():
    global session
    # global session_index, sessions, num_of_sessions
    # session_index = (session_index + 1) % num_of_sessions
    # if sessions[session_index] == None :
    #     sessions[session_index] = create_session()
    # return sessions[session_index]
    if session == None :
        session = create_session()
    return session

def create_session():
    engine = create_engine()
    Session = sessionmaker(bind=engine)
    return Session()

def create_engine():
    setting = DATABASES['default']
    PROTOCOL = 'mysql'
    SERVER_ID = setting['USER']
    SERVER_PW = setting['PASSWORD']
    DOMAIN = '{host}:{port}'.format(host=setting['HOST'], port=setting['PORT'])
    SCHEMA = setting['NAME']
    connection_info = '{protocol}://{server_id}:{server_pw}@{domain}/{schema}?charset=utf8&use_unicode=0'.format(protocol=PROTOCOL, server_id=SERVER_ID, server_pw=SERVER_PW, domain=DOMAIN, schema=SCHEMA)

    return sa_create_engine(connection_info, pool_size=5, encoding='utf8', echo=False)

def to_dict(obj) :
    if isinstance(obj, Base) :
        dic = dict()
        for column in obj.__table__.columns :
            attr = getattr(obj, column.name)
            if isinstance(attr, datetime.datetime):
                dic[column.name] = attr.strftime('%Y/%m/%d %H:%M:%S')
            elif isinstance(attr, datetime.date):
                dic[column.name] = attr.strftime('%Y/%m/%d')
            else :
                dic[column.name] = attr
        for relation in obj.relations :
            dic[relation] = to_dict(getattr(obj, relation))
        return dic
    elif isinstance(obj, list) :
        return [ to_dict(item) for item in obj ]

        
def get_attr_list(list, attr) :
    return [ x.__getattribute__(attr) for x in list ]

def remove_keys(data, model) :
    keys_to_remove = set(data.keys()) - set(model.attrs)
    for key in keys_to_remove :
        del data[key]

def get_paginate_info(request_data) :
    limit, offset = LIMIT, OFFSET
    if 'limit' in request_data :
        limit = request_data['limit']
    if 'offset' in request_data :
        offset = request_data['offset']
    return limit, offset
    
def save_image(image) :
    original_size = (640, 1136) # for iphone5
    thumbnail1_size = (320, 568)
    thumbnail2_size = (160, 284)

    uploaded_image = PIL.Image.open(image)
    original_image_buff = StringIO.StringIO()
    thumbnail1_image_buff = StringIO.StringIO()
    thumbnail2_image_buff = StringIO.StringIO()
    try :
        uploaded_image.thumbnail(original_size, PIL.Image.BICUBIC)
        uploaded_image.save(original_image_buff, 'jpeg')
        uploaded_image.thumbnail(thumbnail1_size, PIL.Image.BICUBIC)
        uploaded_image.save(thumbnail1_image_buff, 'jpeg')
        uploaded_image.thumbnail(thumbnail2_size, PIL.Image.BICUBIC)
        uploaded_image.save(thumbnail2_image_buff, 'jpeg')
    except :
        return None

    image = Image(original_image_buff.getvalue(), thumbnail1_image_buff.getvalue(), thumbnail2_image_buff.getvalue())
    session = create_session()
    session.add(image)
    session.commit()

    uploaded_image_id = image.image_id
    session.close()        

    return uploaded_image_id

