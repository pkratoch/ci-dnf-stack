Feature: Tests for repoclosure command


Background:
  Given I enable plugin "repoclosure"
    And I use repository "repoclosure-upper"


Scenario: Don't report error when available package is required
  Given I use repository "repoclosure-middle"
   When I execute dnf with args "repoclosure --pkg requires-one"
   Then the exit code is 0


Scenario: Report error when unavailable package is required
   When I execute dnf with args "repoclosure --pkg requires-one"
   Then the exit code is 1
    And stdout is
        """
        <REPOSYNC>
        package: requires-one-1-1.x86_64 from repoclosure-upper
          unresolved deps:
            middle-package
        """


Scenario: Don't report error when required package requires unavailable package
  Given I use repository "repoclosure-middle"
      # middle-package has unresolved deps
   When I execute dnf with args "repoclosure --pkg middle-package"
   Then the exit code is 1
    And stdout is
        """
        <REPOSYNC>
        package: middle-package-1-1.x86_64 from repoclosure-middle
          unresolved deps:
            bottom-package
        """
      # requires-one has no unresolved deps, even though it requires middle-package
   When I execute dnf with args "repoclosure --pkg requires-one"
   Then the exit code is 0


Scenario: Report error when one of the required packages is unavailable
  Given I use repository "repoclosure-middle"
   When I execute dnf with args "repoclosure --pkg requires-two"
   Then the exit code is 1
    And stdout is
        """
        <REPOSYNC>
        package: requires-two-1-1.x86_64 from repoclosure-upper
          unresolved deps:
            bottom-package
        """


@xfail
Scenario: Report error when one of the required packages is unavailable (with boolean deps)
  Given I use repository "repoclosure-middle"
   When I execute dnf with args "repoclosure --pkg requires-two-boolean"
   Then the exit code is 1
    And stdout is
        """
        <REPOSYNC>
        package: requires-two-boolean-1-1.x86_64 from repoclosure-upper
          unresolved deps:
            bottom-package
        """


Scenario: Don't report error when required package is in coflict
  Given I use repository "repoclosure-middle"
   When I execute dnf with args "repoclosure --pkg requires-conflicting"
   Then the exit code is 0


Scenario: Don't report error when required package is in default module stream and profile
   When I execute dnf with args "repoclosure --pkg requires-modular"
   Then the exit code is 0


Scenario: Report all errors
   When I execute dnf with args "repoclosure"
   Then the exit code is 1
    And stdout is
        """
        <REPOSYNC>
        package: requires-conflicting-1-1.x86_64 from repoclosure-upper
          unresolved deps:
            conflicting-package
        package: requires-one-1-1.x86_64 from repoclosure-upper
          unresolved deps:
            middle-package
        package: requires-two-1-1.x86_64 from repoclosure-upper
          unresolved deps:
            bottom-package
            middle-package
        package: requires-two-boolean-1-1.x86_64 from repoclosure-upper
          unresolved deps:
            (middle-package and bottom-package)
        """
