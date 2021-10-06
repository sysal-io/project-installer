# wpillar-installer
A local environment manager.

How to trust local certificates on windows: https://www.thewindowsclub.com/manage-trusted-root-certificates-windows

run "certutil -addstore -f "ROOT" rootCA.pem" inside .docker/nginx/cert folder (see https://betterprogramming.pub/trusted-self-signed-certificate-and-local-domains-for-testing-7c6e6e3f9548)