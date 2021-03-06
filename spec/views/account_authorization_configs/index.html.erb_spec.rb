#
# Copyright (C) 2011 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../views_helper')

describe "account_authorization_configs/index" do
  it "should list the auth ips" do
    Setting.set('account_authorization_config_ip_addresses', "192.168.0.1,192.168.0.2")
    assigns[:context] = assigns[:account] = Account.default
    assigns[:account_configs] = [ Account.default.account_authorization_configs.build,
                                  Account.default.account_authorization_configs.build ]
    assigns[:current_user] = user_model
    assigns[:saml_identifiers] = []
    assigns[:saml_authn_contexts] = []
    assigns[:saml_login_attributes] = {}
    render 'account_authorization_configs/index'
    response.body.should match("192.168.0.1\n192.168.0.2")
  end

  it "should display the last_timeout_failure" do
    assigns[:context] = assigns[:account] = Account.default
    assigns[:account_configs] = [ factory_with_protected_attributes(Account.default.account_authorization_configs, :last_timeout_failure => 1.minute.ago),
                                  Account.default.account_authorization_configs.build ]
    assigns[:current_user] = user_model
    assigns[:saml_identifiers] = []
    assigns[:saml_authn_contexts] = []
    assigns[:saml_login_attributes] = {}
    render 'account_authorization_configs/index'
    doc = Nokogiri::HTML(response.body)
    doc.at_css('form.ldap_form:nth(1) tr.last_timeout_failure').should be_present
    doc.at_css('form.ldap_form:nth(2) tr.last_timeout_failure').should_not be_present
  end
end
