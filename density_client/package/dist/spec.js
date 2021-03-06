[
     {'name':      'no-ack-long',
      'type':      'simple',
      'interval':  10000,
      'params':    [{'time-limit': 500}]},
  
     {'name':      'headline-publish',
     'type':      'simple',
     'params':    [{'time-limit':     30,
                    'producer-count': 10,
                    'consumer-count': 0}]},
   
    {'name':      'headline-consume',
     'type':      'simple',
     'params':    [{'time-limit':     30,
                    'producer-count': 1,
                    'consumer-count': 20}]},
  
    {'name':      'no-consume',
     'type':      'simple',
     'params':    [{'time-limit':     30,
                    'consumer-count': 0}]},
   
    {'name':      'no-ack',
     'type':      'simple',
     'params':    [{'time-limit':     30}]},
   
    {'name':      'no-ack-mandatory',
     'type':      'simple',
     'params':    [{'time-limit':     30,
                    'flags':          ['mandatory']}]},
   
    {'name':      'no-ack-immediate',
     'type':      'simple',
     'params':    [{'time-limit':     30,
                    'flags':          ['immediate']}]},
   
    {'name':      'ack',
     'type':      'simple',
     'params':    [{'time-limit':     30,
                    'auto-ack':       false}]},
   
    {'name':      'ack-confirm',
     'type':      'simple',
     'params':    [{'time-limit':     30,
                    'auto-ack':       false,
                    'confirm':        10000}]},
   
    {'name':      'ack-confirm-persist',
     'type':      'simple',
     'params':    [{'time-limit':     30,
                    'auto-ack':       false,
                    'confirm':        10000,
                    'flags':          ['persistent']}]},
  
   {'name':      'ack-persist',
    'type':      'simple',
    'params':    [{'time-limit':     30,
                   'auto-ack':       false,
                   'flags':          ['persistent']}]},
  
   {'name':      'fill-drain-small-queue',
    'type':      'simple',
    'params':    [{'queue-name':         'test',
                    'exclusive':          false,
                    'auto-delete':        true,
                    'producer-msg-count': 500000,
                    'consumer-count':     0},
                   {'queue-name':         'test',
                    'exclusive':          false,
                    'auto-delete':        true,
                    'consumer-msg-count': 500000,
                    'producer-count':     0}]},
   
    {'name':      'fill-drain-large-queue',
     'type':      'simple',
     'params':    [{'queue-name':         'test',
                    'exclusive':          false,
                    'auto-delete':        true,
                    'producer-msg-count': 2000000,
                    'consumer-count':     0},
                   {'queue-name':         'test',
                    'exclusive':          false,
                    'auto-delete':        true,
                    'consumer-msg-count': 2000000,
                    'producer-count':     0}]},
   
    {'name':      'message-sizes-small',
     'type':      'varying',
     'params':    [{'time-limit': 30}],
     'variables': [{'name':   'min-msg-size',
                    'values': [0, 100, 200, 500, 1000, 2000, 5000]}]},
   
    {'name':      'message-sizes-large',
     'type':      'varying',
     'params':    [{'time-limit': 30}],
     'variables': [{'name':   'min-msg-size',
                    'values': [5000, 10000, 50000, 100000, 500000, 1000000]}]},
   
    {'name':      'consumers',
     'type':      'varying',
     'params':    [{'time-limit': 30}],
     'variables': [{'name':   'consumer-count',
                    'values': [1, 2, 5, 10, 50, 100, 500]},
                   {'name':   'prefetch-count',
                    'values': [1, 2, 5, 10, 20, 50, 10000]}]},
   
    {'name':      'message-sizes-and-producers',
     'type':      'varying',
     'params':    [{'time-limit':     30,
                    'consumer-count': 0}],
     'variables': [{'name':   'min-msg-size',
                    'values': [0, 1000, 10000, 100000]},
                   {'name':   'producer-count',
                    'values': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}]},
   
    {'name':      'rate-vs-latency',
     'type':      'rate-vs-latency',
     'params':    [{'time-limit': 30}]}]
