from sanic import Sanic
from sanic.response import json
from celery import Celery
from celery_server import celery_config
from sanic.log import log
from redis_middle.redis_middle_class import Conn_db

from .view.api import api_bp

app = Sanic()

app.blueprint(api_bp)

celery_app = Celery()
celery_app.config_from_object(celery_config)

redis_db = Conn_db()

