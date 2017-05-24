require('cutorch')
require('nn')
require('cunn')
require('cudnn')
require('optim')
require('paths')
require('nngraph')

require('libcrnn')
require('utilities')
require('inference')
require('CtcCriterion')
require('DatasetLmdb')
require('LstmLayer')
require('BiRnnJoin')
require('SharedParallelTable')


cutorch.setDevice(1)
torch.setnumthreads(4)
torch.setdefaulttensortype('torch.FloatTensor')

local modelDir = '/home/ubuntu/crnn/model/crnn_demo/'
paths.dofile(paths.concat(modelDir, 'config.lua'))
local modelLoadPath = paths.concat(modelDir, 'crnn_demo_model.t7')
gConfig = getConfig()
gConfig.modelDir = modelDir
gConfig.maxT = 0
local model, criterion = createModel(gConfig)
local snapshot = torch.load(modelLoadPath)
loadModelState(model, snapshot)
model:evaluate()

local imagePath = '/home/ubuntu/crnn/mc/temp.jpg'
local img = loadAndResizeImage(imagePath)
local text, raw = recognizeImageLexiconFree(model, img)

-- store results to temporary text file so mc-runCRNN.py can read --
print('text' .. '\t' .. 'raw')
