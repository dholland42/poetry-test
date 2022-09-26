"""Tests to check the behavior under different versions of poetry."""


def test_thing():
    """Always passes."""
    from testdots.cooltest import constants
    assert constants.THING == 3


def test_version():
    """Fails on poetry 1.2.1, passes on 1.1.13."""
    import pkg_resources
    assert pkg_resources.get_distribution('testdots.cooltest').version == '0.1.0'


def test_version_dash_replace():
    """Passes on both versions of poetry."""
    import pkg_resources
    assert pkg_resources.get_distribution('testdots-cooltest').version == '0.1.0'
