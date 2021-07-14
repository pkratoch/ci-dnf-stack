Feature: Test bug 1963271


@xfail
@bz1963271
Scenario: When selinux-policy of lower version is installed and I install usbguard, selinux-policy is upgraded (instead of installing older usbguard-selinux and usbguard)
  Given I use repository "bz1963271"
    And I successfully execute dnf with args "install selinux-policy-1.0"
   When I execute dnf with args "install usbguard"
   Then the exit code is 0
    And Transaction is following
        | Action        | Package                             |
        | install       | usbguard-0:2.0-1.x86_64             |
        | install-weak  | usbguard-selinux-0:2.0-1.x86_64     |
        | upgrade       | selinux-policy-0:2.0-1.x86_64       |

# Current DNF behavior:
#    And Transaction is following
#        | Action        | Package                             |
#        | install       | usbguard-0:2.0-1.x86_64             |
#        | install-dep   | usbguard-0:1.0-1.i686               |
#        | install-weak  | usbguard-selinux-0:1.0-1.x86_64     |


@xfail
@bz1963271
Scenario: When selinux-policy of lower version is installed and I install yolo, yolo-selinux is installed in the newer version together with upgrading selinux-policy (instead of installing yolo-selinux in older version)
  Given I use repository "bz1963271"
    And I successfully execute dnf with args "install selinux-policy-1.0"
   When I execute dnf with args "install yolo"
   Then the exit code is 0
    And Transaction is following
        | Action        | Package                             |
        | install       | yolo-0:2.0-1.x86_64                 |
        | install-weak  | yolo-selinux-0:2.0-1.x86_64         |
        | upgrade       | selinux-policy-0:2.0-1.x86_64       |

# Current DNF behavior:
#    And Transaction is following
#        | Action        | Package                             |
#        | install       | yolo-0:2.0-1.x86_64                 |
#        | install-weak  | yolo-selinux-0:1.0-1.x86_64         |

