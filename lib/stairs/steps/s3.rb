module Stairs
  module Steps
    class S3 < Step
      title "S3"
      description "Setup AWS and S3 bucket access"

      def run
        env "AWS_ACCESS_KEY_ID", provide("AWS Access Key ID")
        env "AWS_SECRET_ACCESS_KEY", provide("AWS Secret Access Key")
        env "AWS_S3_BUCKET", provide("S3 Bucket name")
      end
    end
  end
end