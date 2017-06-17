#!/usr/bin/env python3

import os
import sys
import json

import backoff
import requests

from requests.exceptions import RequestException


API_URL='http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i='
DATA_PATH = 'data'


@backoff.on_exception(backoff.expo, RequestException, max_tries=10)
def fetch_by_id(obj_id):
    res = requests.get('{}{}'.format(API_URL, obj_id))
    if res.status_code != 200:
        return None

    data = res.json()
    if 'drinks' not in data or not data['drinks']:
        return None

    return data


def save_record(obj_id, data):
    filepath = '{}/{}.json'.format(DATA_PATH, obj_id)
    with open(filepath, 'w') as f:
        json.dump(data, f)


def main():
    if len(sys.argv) != 3:
        print('usage: ./scraps.py [BEGIN] [END]')
        sys.exit(1)

    begin = int(sys.argv[1])
    end = int(sys.argv[2])

    for obj_id in range(begin, end):
        print('fetch:', obj_id)
        record = fetch_by_id(obj_id)
        if record:
            print('save:', obj_id)
            save_record(obj_id, record)
        else:
            print('warn: empty', obj_id)


if __name__ == '__main__':
    main()
