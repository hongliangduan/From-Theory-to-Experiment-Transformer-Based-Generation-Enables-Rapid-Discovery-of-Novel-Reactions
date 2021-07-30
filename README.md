# From Theory to Experiment: Transformer-Based Generation Enables Rapid Discovery of Novel Reactions
This is the code for "From Theory to Experiment: Transformer-Based Generation Enables Rapid Discovery of Novel Reactions" paper. 


# Conda Environemt Setup
conda env create -f environment.yaml


# Dataset
The data for training and valid of Heck coupling reaction are provided in ```data``` folder. 


# Quickstart
# Step 1: Preprocess the data
Put ```train.txt``` and ```valid.txt``` files into ```data/reaction``` folder
Run the ```bash generation.sh train_data``` in ```generation.sh``` script

# Step 2. Train the model 
Run the ```bash generation.sh train``` in ```generation.sh``` script

## After run the training, the following files are generated
```model.ckpt```: model generated ckpt was put in ```model\ckpt_path```

# Step 3. Generated reactions
Run the ```bash generation.sh inference``` in ```generation.sh``` script

