# -*- coding:utf-8 -*-

from django.utils import simplejson as json
from sqlalchemy import func
from sqlalchemy import Binary, Boolean, Column, Date, DateTime, Float, ForeignKey, Integer, String, Text
from sqlalchemy.dialects.mysql import BLOB, MEDIUMBLOB, TIMESTAMP
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, backref

import md5
import uuid

Base = declarative_base()
Base.relations = []
# example of Model 

# class ModelName(Base) :
#     # each block is seperated by '\n'
#     __tablename__ = 'the table name in database'

#     # primary key and foreign keys
#     id = Column(Integer, primary_key=True)
#     for_id = Column(Integer, ForeignKey('table.id'))

#     # relationships    
#     another_model = relationship('AnotherModel')
#     another_model2 = relationship('AnotherModel2')

#     # attributes
#     attr1 = Column(String(50))
    
#     # list of attribute name for calling the constructor easily 
#     # does not include primary key and foreign keys
#     # trailing ',' is for convinient to add another attribute and removes the chances of typo
#     attrs = ['attr1', ]

#     # list of relations to apply to_dict function, if relation is not in relations
#     # to_dict function does not include relation's object info into the result dict
#     # relations 가 없더라도 넣어주자!
#     # Base에 있는 relations는 class member이기때문에 쓰렉임... 그냥 에러방지용
#     relations = ['another_model', ]

#     # define constructor with all attribute as keyworded formal param with default value
#     def __init__(self, attr1=None):
#         self.attr1 = attr1
    
#     # repr method return the format like '<ModelName {id} other infos>' 
#     def __repr__(self) :
#         return '<ModelName {id}>'.format(id=self.id)

class Image(Base) :
    __tablename__ = 'images'
    
    image_id = Column(Integer, primary_key=True)
    
    image = Column(MEDIUMBLOB)
    thumbnail1_image = Column(BLOB)
    thumbnail2_image = Column(BLOB)
    attrs = ['image', 'thumbnail1_image', 'thumbnail2_iamge', ]

    def __init__(self, image=None, thumbnail1_image=None, thumbnail2_image=None) :
        self.image = image
        self.thumbnail1_image = thumbnail1_image
        self.thumbnail2_image = thumbnail2_image

    def __repr__(self) :
        return '<Image {image_id}>'.format(image_id = self.image_id)


class Spot(Base) :
    __tablename__ = 'spots'

    spot_id = Column(Integer, primary_key=True)    
    king_id = Column(Integer, ForeignKey('user_infos.user_id', use_alter=True, name='fk_spot_kinginfo'))
    queen_id = Column(Integer, ForeignKey('user_infos.user_id', use_alter=True, name='fk_spot_queen'))

    name = Column(String(50))
    lat = Column(Float)
    lng = Column(Float)
    description = Column(Text)
    is_private = Column(Boolean)
    price = Column(Float)
    popularity = Column(Float)
    created = Column(DateTime, default=func.current_timestamp())

    assoc = relationship('SpotUserAssociation', backref='spot')
    king = relationship('UserInfo', primaryjoin='UserInfo.user_id==Spot.king_id')
    queen = relationship('UserInfo', primaryjoin='UserInfo.user_id==Spot.queen_id')

    attrs = ['spot_id', 'king_id', 'queen_id', 'name', 'lat', 'lng', 'description', 'is_private', 'price', 'popularity', 'created', ]
    
    def __init__(self, spot_id=None, name=None, lat=None, lng=None, description=None, is_private=False, price=None, popularity=None, created=None) :
        self.spot_id = spot_id
        self.name = name
        self.lat = lat
        self.lng = lng
        self.description = description
        self.is_private = is_private
        self.price = price
        self.popularity = popularity
        self.created = created

    def __repr__(self):
        return '<Spot {spot_id}>'.format(spot_id=self.spot_id)

class SpotProfileImage(Base):
    __tablename__ = 'spot_profile_images'

    spot_id = Column(Integer, ForeignKey('spots.spot_id', use_alter=True, name='fk_spotimage_spot'), primary_key=True)
    image = Column(MEDIUMBLOB)
    thumbnail_image = Column(BLOB)

    attrs = ['image', 'thumbnail_image', ]

    def __init__(self, spot_id=None, image=None, thumbnail_image=None):
        self.spot_id = spot_id
        self.image = image
        self.thumbnail_image = thumbnail_image

class SpotUserAssociation(Base) :
    __tablename__ = 'spot_user'

    spot_id = Column(Integer, ForeignKey('spots.spot_id', use_alter=True, name='fk_su_assoc_spot'), primary_key=True)
    user_id = Column(Integer, ForeignKey('user_infos.user_id', use_alter=True, name='fk_su_assoc_user'), primary_key=True)
    
    can_snap = Column(Boolean)
    jointime = Column(DateTime, default=func.current_timestamp())

    userinfo = relationship('UserInfo', backref='assoc')
    
    attrs = ['can_snap', 'joined', ] 

    relations = []

    def __init__(self, spot_id=None, user_id=None, can_snap=False):
        self.spot_id = spot_id
        self.user_id = user_id
        self.can_snap = can_snap
    
    def __repr__(self) :
        return '<SpotUserAssociation spot : {spot_id}, user : {user_id}>'.format(spot_id=self.spot_id, user_id=self.user_id)

class Snap(Base) :
    __tablename__ = 'snaps'
    
    snap_id = Column(Integer, primary_key=True)    
    spot_id = Column(Integer, ForeignKey('spots.spot_id', use_alter=True, name='fk_snap_spot'))
    user_id = Column(Integer, ForeignKey('user_infos.user_id', use_alter=True, name='fk_snap_user'))
    image_id = Column(Integer, ForeignKey('images.image_id', use_alter=True, name='fk_snap_image'))

    userinfo = relationship('UserInfo', uselist=False)
    comments = relationship('SnapComment')
    likes = relationship('SnapLike')

    snaptime = Column(DateTime, default=func.current_timestamp())
    lat = Column(Float)
    lng = Column(Float)    
    description = Column(Text)
    user_nickname = Column(String(20))
    spot_name = Column(String(50))
    
    attrs = ['spot_id', 'user_id', 'image_id', 'snaptime', 'lat', 'lng', 'description', 'user_nickname', 'spot_name']

    relations = ['userinfo', 'comments', 'likes' ]

    def __init__(self, spot_id=None, user_id=None, image_id=None, snaptime=None, lat=None, lng=None, description=None, user_nickname=None, spot_name=None) :
        self.spot_id = spot_id
        self.user_id = user_id
        self.image_id = image_id
        self.lat = lat
        self.lng = lng
        self.snaptime = snaptime
        self.description = description
        self.user_nickname = user_nickname
        self.spot_name = spot_name

    def __repr__(self) :
        return '<Snap {snap_id} in Spot {spot_id}>'.format(snap_id=self.snap_id, spot_id=self.spot_id)

class SnapComment(Base) :
    __tablename__ = 'snap_comments'
    
    id = Column(Integer, primary_key=True)
    snap_id = Column(Integer, ForeignKey('snaps.snap_id', use_alter=True, name='fk_snap_comment_snap'))
    spot_id = Column(Integer, ForeignKey('spots.spot_id', use_alter=True, name='fk_snap_comment_spot'))
    user_id = Column(Integer, ForeignKey('user_infos.user_id', use_alter=True, name='fk_snap_comment_user'))

    userinfo = relationship('UserInfo', uselist=False)
    
    created = Column(DateTime, default=func.current_timestamp())
    comment = Column(Text)

    attrs = ['id', 'snap_id', 'spot_id', 'user_id', 'created', 'comment', ]

    relations = ['userinfo', ]

    def __init__(self, id=None, snap_id=None, spot_id=None, user_id=None, created=None, comment=None) :
        self.id = id
        self.snap_id = snap_id
        self.spot_id = spot_id
        self.user_id = user_id
        self.created = created
        self.comment = comment

    def __repr__(self) :
        return '<SnapComment {id} for Snap {snap_id}>'.format(id=self.id, snap_id=self.snap_id)

class SnapLike(Base) :
    __tablename__ = 'snap_likes'
    
    snap_id = Column(Integer, ForeignKey('snaps.snap_id', use_alter=True, name='fk_snap_like_snap'), primary_key=True)
    user_id = Column(Integer, ForeignKey('user_infos.user_id', use_alter=True, name='fk_snap_like_user'), primary_key=True)
    spot_id = Column(Integer, ForeignKey('spots.spot_id', use_alter=True, name='fk_snap_like_spot'))

    liketime = Column(DateTime, default=func.current_timestamp())

    attrs = ['snap_id', 'user_id', 'spot_id', 'liketime', ]
    # make association between SnapLike and UserInfo

    # implement this
    def __init__(self, snap_id=None, user_id=None, spot_id=None) :
        self.snap_id = snap_id
        self.user_id = user_id
        self.spot_id = spot_id

    # implement this
    def __repr__(self) :
        return '<SnapLike User {user_id} like Snap {snap_id} in Spot {spot_id}>'.format(user_id=self.user_id, snap_id=self.snap_id, spot_id=self.spot_id)


class User(Base) :
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)

    user_id = Column(String(50))
    user_password = Column(String(32))

    userinfo = relationship("UserInfo", uselist=False)

    attrs = ['user_id', 'id', 'user_password', ]

    def __init__(self, id=None, user_id=None, user_password=None) :
        self.id = id
        self.user_id = user_id
        self.user_password = md5.new(user_password).hexdigest()
        
    def __repr__(self):
        return '<User {id}>'.format(id = self.id)
        
class UserInfo(Base) :
    __tablename__ = 'user_infos'
    
    user_id = Column(Integer, ForeignKey('users.id'), primary_key=True)

    created = Column(DateTime, default=func.current_timestamp())
    gender = Column(String(1))
    phone_number = Column(String(20))
    email = Column(String(60))
    nickname = Column(String(20))
    facebook = Column(String(30))
    homepage = Column(String(100))
    workplace = Column(String(60))
    birthday = Column(Date)
    description = Column(Text)
    is_admin = Column(Boolean)

    snap_list = relationship('Snap')
    
    # is_admin은 목록에 추가하지 않았음. 관리자가 따로 변경할 수 있도록 하는 조취
    attrs = ['created', 'gender', 'phone_number', 'email', 'nickname', 'facebook', 'homepage', 'workplace', 'birthday', 'description', ]

    def __init__(self, nickname=None, gender=None, phone_number=None, email=None, homepage=None, workplace=None, birthday=None, description=None, is_admin=False) :
        self.gender = gender
        self.phone_number = phone_number
        self.email = email
        self.nickname = nickname
        self.homepage = homepage
        self.workplace = workplace
        self.birthday = birthday
        self.description = description
        self.is_admin = False
        
    def __repr__(self) :
        return '<UserInfo {user_id}>'.format(user_id = self.user_id)

class UserProfileSnap(Base) :
    __tablename__ = 'user_profile_snaps'

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('user_infos.user_id'))

    snaptime = Column(DateTime, default=func.current_timestamp())

    user_profile_snap_image = relationship('UserProfileSnapImage')

    relations = ['user_profile_snap_image', ]

    def __init__(self, user_id=None, user_profile_snap_image=None):
        self.user_id = user_id
        self.user_profile_snap_image = user_profile_snap_image

class UserProfileSnapImage(Base):
    __tablename__ = 'user_profile_snap_images'
    
    image_id = Column(Integer, ForeignKey('user_profile_snaps.id'), primary_key=True)
    
    image = Column(MEDIUMBLOB)
    thumbnail_image = Column(BLOB)

    attrs = ['image', 'thumbnail_image', ]

    def __init__(self, image_id=None, image=None, thumbnail_image=None):
        self.image_id = image_id
        self.image = image
        self.thumbnail_image = thumbnail_image

class UserProfileImage(Base) :
    __tablename__ = 'user_profile_images'
    
    user_id = Column(Integer, ForeignKey('user_infos.user_id'), primary_key=True)
    
    image = Column(MEDIUMBLOB)
    thumbnail_image = Column(BLOB)

    attrs = ['image', 'thumbnail_image', ]
    
    def __init__(self, user_id=None, image=None, thumbnail_image=None) :
        self.user_id = user_id
        self.image = image
        self.thumbnail_image = thumbnail_image


# dependency 
'''
Snap -> Image, Spot, UserInfo
SnapComment -> Snap, UserInfo
SnapLike -> Snap, UserInfo
SpotUserAssociation -> Spot, UserInfo
UserInfo -> User
UserProfileSnap -> UserInfo
UserProfileSnapImage -> UserProfileSnap
UserProfileImage -> UserInfo
'''
# list items are ordered by their dependency
# this is for create_table script
modellist = [Image, Spot, SpotProfileImage, User, UserInfo, UserProfileSnap, UserProfileSnapImage, UserProfileImage, SpotUserAssociation, Snap, SnapComment, SnapLike, ] 
