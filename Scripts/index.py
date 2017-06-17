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
        image = '{}/{}-Medium.png'.format(INGREDIENT_IMAGE_URL, ingredient)

        if ingredient:
            ingredients.append({
                'name': ingredient,
                'measure': measure,
                'image': image
            })

    new['ingredients']= ingredients
    return new


def main():
    if len(sys.argv) != 2:
        print('usage: ./index.py [PATHNAME]')
        sys.exit(1)

    batch = []
    filenames = os.listdir(sys.argv[1])

    for filename in filenames:
        pathname = '{}/{}'.format(sys.argv[1], filename)
        print(pathname)

        with open(pathname) as f:
            data = json.load(f)

        r = mapping(data)
        batch.append(r)

    client = algoliasearch.Client("QJD6ORETUC",
                                  "XXX_CHANGE_ME")
    index = client.init_index("Cocktail-Kit")
    index.add_objects(batch)


if __name__ == '__main__':
    main()
