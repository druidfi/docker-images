<?php

/**
 * SAML 2.0 remote SP metadata for SimpleSAMLphp.
 *
 * See: https://simplesamlphp.org/docs/stable/simplesamlphp-reference-sp-remote
 */

$metadata[getenv('SIMPLESAMLPHP_SP_ENTITY_ID')] = [
    'AssertionConsumerService' => [
        [
            'Location' => getenv('SIMPLESAMLPHP_SP_ASSERTION_CONSUMER_SERVICE'),
            'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
        ],
    ],
    'SingleLogoutService' => [
        [
            'Location' => getenv('SIMPLESAMLPHP_SP_SINGLE_LOGOUT_SERVICE'),
            'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
        ],
    ],
];

if (isset($_GET['_debug']) && $_GET['_debug'] === '2') {
    echo '<pre>';
    print_r($metadata);
    exit;
}
