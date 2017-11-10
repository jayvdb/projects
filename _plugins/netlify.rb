module Jekyll
  module Netlify
    class Generator < Jekyll::Generator

      safe true

      def generate(site)
        if is_netlify?
          site.config['netlify'] = load_netlify_env(site)
        else
          site.config['netlify'] = false
        end
      end

      def is_netlify?
        if ENV.has_key?('DEPLOY_URL')
          deploy_url = ENV['DEPLOY_URL']
          if deploy_url.include? 'netlify'
            true
          end
        end
      end

      def is_pull_request?
        ENV['PULL_REQUEST'].to_s.eql?('true') ? true : false
      end

      def load_netlify_env(site)
        data = {
          'repository_url' => ENV['REPOSITORY_URL'],
          'branch' => ENV['BRANCH'],
          'pull_request' => is_pull_request?,
          'head' => ENV['HEAD'],
          'commit' => ENV['COMMIT_REF'],
          'context' => ENV['CONTEXT'],
          'deploy_url' => ENV['DEPLOY_URL'],
          'url' => ENV['URL'],
          'deploy_prime_url' => ENV['DEPLOY_PRIME_URL'],
        }
        if ENV.has_key?('WEBHOOK_URL')
          webhook = {
            'title' => ENV['WEBHOOK_TITLE'],
            'body' => ENV['WEBHOOK_BODY'],
            'url' => ENV['WEBHOOK_URL'],
          }
          data['webhook'] = webhook
        else
          data['webhook'] = false
        end
        data
      end
    end
  end
end
