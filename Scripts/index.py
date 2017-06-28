#!/usr/bin/env python3

import os
import sys
import json

from algoliasearch import algoliasearch


INGREDIENT_IMAGE_URL = 'http://www.thecocktaildb.com/images/ingredients/'


def mapping(data):
    d = data['drinks'][0]
    new = {
        'objectID': d['idDrink'],
        'name': d['strDrink'],
        'category': d['strCategory'],
        'isAlcoholic': d['strAlcoholic'] == 'Alcoholic',
        'glass': d['strGlass'],
        'instructions': d['strInstructions'],
        'image': d['strDrinkThumb'],
        'dateModified': d['dateModified']
    }

    ingredients = []
    for i in range(1, 16):
        ingredient = d['strIngredient{}'.format(i)]
        measure = d['strMeasure{}'.format(i)]
        image = '{}/{}-Small.png'.format(INGREDIENT_IMAGE_URL, ingredient)

        if ingredient:
            ingredients.append({
                'name': ingredient.strip(),
                'measure': measure.strip(),
                'image': image
            })

    new['ingredients'] = ingredients
    return new


def should_keep(r):
    return all(r[field] for field in ['name', 'instructions', 'image'])


def main():
    if len(sys.argv) != 2:
        print('usage: ./index.py [PATHNAME]')
        sys.exit(1)

    app_id = os.getenv('ALGOLIA_APPLICATION_ID')
    api_key = os.getenv('ALGOLIA_API_KEY')

    if not (app_id and api_key):
        print('Please define ALGOLIA_APPLICATION_ID and ALGOLIA_API_KEY env.')
        sys.exit(1)

    batch = []
    filenames = os.listdir(sys.argv[1])

    for filename in filenames:
        pathname = '{}/{}'.format(sys.argv[1], filename)
        print(pathname)

        with open(pathname) as f:
            data = json.load(f)

        r = mapping(data)
        if should_keep(r):
            batch.append(r)

    for i, r in enumerate(batch):
        r['objectID'] = i

    client = algoliasearch.Client(app_id, api_key)
    index = client.init_index("Cocktail-Kit")
    index.clear_index()
    index.add_objects(batch)


if __name__ == '__main__':
    main()
