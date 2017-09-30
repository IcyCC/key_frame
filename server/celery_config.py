CELERY_IMPORTS = ("celery_server.task",)

BROKER_URL = 'redis://127.0.0.1/0'
CELERY_RESULT_BACKEND = 'redis://127.0.0.1/0'

CELERY_QUEUES = {"words":{
                "exchange":"words",
                 "exchange_type":"direct",
                    "binding_key":"words"
},
"test":{
                "exchange":"test",
                 "exchange_type":"direct",
                    "binding_key":"test"
            }
        }

# CELERY_ROUTES = {
#     "celery_server.task":{
#         "queue":"words",
#         "routing_key":"words"
#     }
# }