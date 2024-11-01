Feature: Logs


@xfail
# https://github.com/rpm-software-management/dnf5/issues/1819
@bz1802074
Scenario Outline: logfilelevel <level> controls verbosity of dnf.log
Given I use repository "dnf-ci-fedora-updates"
 When I configure dnf with
      | key          | value   |
      | logfilelevel | <level> |
  And I execute dnf with args "install flac"
  And I execute dnf with args "remove flac"
 Then file "/var/log/dnf5.log" contains lines
      """
      <info_lines>
      <debug_lines>
      <ddebug_lines>
      """
  And file "/var/log/dnf5.log" does not contain lines
      """
      <not_present>
      """

Examples:
      | level | info_lines | debug_lines | ddebug_lines | not_present   |
      | 0     |            |             |              | .* INFO .*    |
      | 1     | .* INFO .* |             |              | .* DEBUG .*   |
      | 3     | .* INFO .* | .* DEBUG .* |              | .* DDEBUG .*  |
      | 7     | .* INFO .* | .* DEBUG .* | .* DDEBUG .* | .* WARNING .* |


@bz1910084
Scenario: Logfiles are created with 644 permissions by default
Given I use repository "dnf-ci-fedora-updates"
 When I execute dnf with args "install flac"
 Then the exit code is 0
  And file "/var/log/dnf5.log" has mode "644"


@bz1910084
Scenario: Created logfiles respect umask setting
Given I use repository "dnf-ci-fedora-updates"
 When I set umask to "0066"
  And I execute dnf with args "install flac"
 Then the exit code is 0
  And file "/var/log/dnf5.log" has mode "600"
Given I set umask to "0022"


@xfail
# https://github.com/rpm-software-management/dnf5/issues/1820
@bz1910084
Scenario: Log rotation keeps file permissions
Given I use repository "dnf-ci-fedora-updates"
  And I successfully execute dnf with args "install flac"
    # Set permissions to 600
  And I successfully execute "chmod 600 {context.dnf.installroot}/var/log/dnf5.log"
    # Run dnf again, so that files are rotated
 When I execute dnf with args "--setopt=log_size=100 --setopt=log_rotate=2 remove flac"
 Then the exit code is 0
  And file "/var/log/dnf5.log" has mode "600"
  And file "/var/log/dnf5.log.1" has mode "600"
