output "release_name" {
  description = "The TeamCIty release name"
  value = helm_release.teamcity.name
}