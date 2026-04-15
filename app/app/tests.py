"""
simple test case
"""
from django.test import SimpleTestCase

from app import calc


class TestAdd(SimpleTestCase):

    def test_add(self):
        res = calc.add(2, 3)
        self.assertEqual(res, 5)

    def test_substract(self):
        res = calc.substract(5, 2)
        self.assertEqual(res, 3)
