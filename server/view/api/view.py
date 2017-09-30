from sanic import Blueprint
from sanic.request import Request
from server import app, celery_app, redis_db
from . import api_bp


@api_bp.route("/upload_key_word")
async def upload_key_word(request:Request):
    words = request.args.get('keys')
    res = celery_app.send_task(routing_key='words', queue='words', link=write_to_redis)
    pass


@api_bp.route("/upload_key_image")
async def upload_key_image(request:Request):
    image_file = request.files.get('key_image')
    pass


def write_to_redis(resp):
    r = resp.result()
    return r
