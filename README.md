# Table of Contents

1. [Description](#payme)
2. [Screenshots](#screenshots)
    1. [Delivery App Mode](#delivery-app-mode-default)
    2. [Manual Mode](#manual-mode)
    3. [What Happened](#what-happened)
    4. [Output](#output)
    5. [Venmo Preview](#venmo-preview)
3. [How-Tos](#how-tos)
    1. [Run](#run)
    2. [Host](#host)

# PayMe
Just a simple repo to calculate how much to request from people after a night out

# Screenshots

## Delivery App Mode (default)

 <img src="https://github.com/pomkos/payme/blob/main/images/default_view.png" width="620"> 

## Manual Mode

<img src="https://github.com/pomkos/payme/blob/main/images/manual_mode.png" width="620">

## What Happened

<img src="https://github.com/pomkos/payme/blob/main/images/what_happened.png" width="620">

## Output

<img src="https://github.com/pomkos/payme/blob/main/images/testaurant_output.png" width="620">

## Venmo Preview

<img src="https://github.com/pomkos/payme/blob/main/images/venmo_preview.png" width="620">

# How tos
## Run

1. Clone the repository:
```
git clone https://github.com/pomkos/payme
cd payme
```

2. Create a conda environment (optional):

```
conda create --name "pay_env"
```

3. Activate environment, install python, install dependencies.

```
conda activate pay_env
conda install python=3.8
pip install -r requirements.txt
```
3. Start the application:
```
streamlit run payme.py
```
5. Access the application at `localhost:8501`

## Host

Use the [streamlit_starter](https://github.com/pomkos/streamlit_starter) repo, or follow the instructions below.

1. Create a new file outside the `payme` directory:

```
cd
nano payme.sh
```

2. Paste the following in it, then save and exit:

```
#!/bin/bash

source ~/anaconda3/etc/profile.d/conda.sh

cd ~/payme
conda activate pay_env

nohup streamlit run payme.py --server.port 8503 &
```

3. Edit crontab so portfolio is started when server reboots

```
crontab -e
```

4. Add the following to the end, then save and exit

```
@reboot /home/payme.sh --server.port 8503
```

5. Access the website at `localhost:8503`
