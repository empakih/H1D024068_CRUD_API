<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class RestfulController extends ResourceController
{
    protected $format = 'json';

    public function initController(\CodeIgniter\HTTP\RequestInterface $request, \CodeIgniter\HTTP\ResponseInterface $response, \Psr\Log\LoggerInterface $logger)
    {
        parent::initController($request, $response, $logger);

        // CORS headers
        $this->response->setHeader('Access-Control-Allow-Origin', '*');
        $this->response->setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
        $this->response->setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
    }

    protected function responseHasil($code, $status, $data)
    {
        return $this->respond([
            'code' => $code,
            'status' => $status,
            'data' => $data
        ]);
    }
}
