resource "aws_cognito_user_pool" "jikokanriUserPool" {
  name = "jikokanri_user_pool"
}

resource "aws_cognito_user_pool_client" "jikokanriUserPoolClient" {
  name = "jikokanri_user_pool_client"

  user_pool_id = aws_cognito_user_pool.jikokanriUserPool.id
}