#!/usr/bin/env python3
"""Offline unit tests for scripts/sync_data.py helpers. Run: python3 scripts/test_sync_data.py"""
import unittest

import sync_data


class SlugTests(unittest.TestCase):
    def test_control_code(self):
        self.assertEqual(sync_data.slug("G.1.1"), "g-1-1")

    def test_group_code(self):
        self.assertEqual(sync_data.slug("G"), "g")

    def test_two_digit_control(self):
        self.assertEqual(sync_data.slug("E.3.10"), "e-3-10")


class RoleIndexTests(unittest.TestCase):
    def test_maps_code_to_every_role_that_lists_it(self):
        roles = [
            {"id": "SS", "name": "Software Security", "description": "", "tasks": ["G.1.1", "G.1.2"]},
            {"id": "BM", "name": "Business Management", "description": "", "tasks": ["G.1.2"]},
        ]
        index = sync_data.build_role_index(roles)
        self.assertEqual(index["G.1.1"], ["SS"])
        self.assertEqual(index["G.1.2"], ["SS", "BM"])

    def test_unknown_code_absent(self):
        index = sync_data.build_role_index([{"id": "SS", "name": "x", "description": "", "tasks": ["G.1.1"]}])
        self.assertNotIn("Z.9.9", index)


if __name__ == "__main__":
    unittest.main()
