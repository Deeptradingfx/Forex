from __future__ import print_function
import numpy as np
import cntk

def LoadData(fn,is_training):
    n=".\\Data\\"+fn
    datainp=cntk.io.StreamDef("features",45)
    dataout=cntk.io.StreamDef("labels",2)
    dataall=cntk.io.StreamDefs(features=datainp,labels=dataout)
    st=cntk.io.CTFDeserializer(n,dataall)
    mbs=cntk.io.MinibatchSource(st,randomize = is_training,max_sweeps = cntk.io.INFINITELY_REPEAT if is_training else 1)
    return mbs

def nn(x):
    m=cntk.layers.Recurrence(cntk.layers.LSTM(45))(x)
    for i in range(0,20):
         m=cntk.layers.Recurrence(cntk.layers.LSTM(200))(m)
    m=cntk.layers.Recurrence(cntk.layers.LSTM(2))(m)
    return m

input_var = cntk.input_variable(45,np.float32, name = 'features',dynamic_axes=cntk.axis.Axis.default_input_variable_dynamic_axes())
label_var=cntk.input_variable(2,np.float32, name = 'labels',dynamic_axes=cntk.axis.Axis.default_input_variable_dynamic_axes())

def train(streamf):
    global net
    net=nn(input_var)
    loss = cntk.squared_error(net,label_var)
    error=cntk.squared_error(net,label_var)
    learning_rate=0.001
    lr_schedule=cntk.learning_rate_schedule(learning_rate,cntk.UnitType.minibatch)
    momentum_time_constant = cntk.momentum_as_time_constant_schedule(700)
    learner=cntk.fsadagrad(net.parameters,lr=lr_schedule,momentum = momentum_time_constant,unit_gain = True)
    progres=cntk.logging.ProgressPrinter(0)
    trainer=cntk.Trainer(net,(loss,error),[learner],progress_writers=progres)
    input_map={
        input_var : streamf.streams.features,
        label_var : streamf.streams.labels
        
    }
    minibatch_size =  512
    max_epochs = 100
    epoch_size = 48985
    t = 0
    for epoch in range(max_epochs):
        epoch_end = (epoch+1) * epoch_size
        while t < epoch_end: 
            dat1=streamf.next_minibatch(minibatch_size,input_map = input_map)
            trainer.train_minibatch(dat1)
            t += dat1[label_var].num_samples
    trainer.summarize_training_progress()
    return trainer

def test(streamf):
    input_map={
        input_var : streamf.streams.features,
        label_var : streamf.streams.labels   
    }
    minibatch_size =  512
    loss = cntk.binary_cross_entropy(net,label_var)
    progress_printer = cntk.logging.ProgressPrinter(tag='Evaluation', num_epochs=0)
    evaluator = cntk.eval.Evaluator(loss, progress_printer)
    while True:
        dat1=streamf.next_minibatch(minibatch_size,input_map = input_map)
        if not dat1:
            break
        evaluator.test_minibatch(dat1)
    evaluator.summarize_test_progress()


data=LoadData("train.txt",True)
model1=train(data)
md=model1.model
md.save(".\\Model\\model.cmf")
print("========================")
data1=LoadData("test.txt",False)
test(data1)
g=input("Нажмите любую клавишу")

