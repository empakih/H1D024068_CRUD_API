<?php

namespace App\Controllers;

use App\Models\MRegistrasi;

class RegistrasiController extends RestfulController
{
    public function registrasi()
    {
        $json = $this->request->getJSON(true);
        $data = [
            'nama' => $json['nama'] ?? $this->request->getVar('nama'),
            'email' => $json['email'] ?? $this->request->getVar('email'),
            'password' => password_hash($json['password'] ?? $this->request->getVar('password'), PASSWORD_DEFAULT)
        ];

        $model = new MRegistrasi();
        $model->save($data);
        return $this->responseHasil(200, true, "Registrasi Berhasil");
    }
}

