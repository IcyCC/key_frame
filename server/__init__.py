import sanic
from sanic.response import json,file_stream
import ujson
from celery import Celery
from . import celery_config
from sanic.log import log
from redis_middle.redis_middle_class import Conn_db
from server.keyframe_extraction.scripts.ScriptOfCp.celery_server.task import eng
app = sanic.Sanic(__name__)
app.debug = True


celery_app = Celery()
celery_app.config_from_object(celery_config)

redis_db = Conn_db()


video_url = "/home/suchang/Code/school/server/keyframe_extraction/scripts/ScriptOfCp/"
base_url = '/static/'


app.static('/static', '/home/suchang/Code/school/keyframe_extraction/scripts/ScriptOfCp/test')


@app.route("/key_frames",methods=['GET'])
async def upload_key_word(request):
    key_words = request.args.get('words')

    key_words = ujson.loads(key_words)

    result = eng.get_info(key_words[0],key_words[1], key_words[2], nargout=1)

    resp = dict(video_url=video_url+result[0][0], data=list())

    for item in result:
        resp.get('data',[]).append({'video_name': item[0],
                                    "image_url": base_url+item[1],
                                    "time": item[2]})
    return json(body=resp)


@app.route('/video', methods=['GET'])
async def get_video(request):
    path = request.args.get('path')
    return await file_stream(path)

@app.route("/upload_key_image")
async def upload_key_image(request):
    image_file = request.files.get('key_image')
    pass


def write_to_redis(resp):
    r = resp.result()
    return r
