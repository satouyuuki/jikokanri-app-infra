/**
 * valiable
 **/
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
  default = "ap-northeast-1"
}
variable "site_domain" {
  default = "app.sy-jikankanri.work"
}
variable "api_server_domain" {
  default = "api.sy-jikankanri.work"
}
variable "root_domain" {
  default = "sy-jikankanri.work"
}
variable "bucket_name" {
  default = "s3-sy-jikankanri.work"
}
