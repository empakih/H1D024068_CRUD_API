<?php

namespace App\Controllers;

use App\Models\MRegistrasi;

class RegistrasiController extends RestfulController
{
    public function registrasi()
    {
        $nama = $this->request->getVar('nama');
        $email = $this->request->getVar('email');
        $password = $this->request->getVar('password');

        if ($nama === null || $email === null || $password === null) {
            try {
                $json = $this->request->getJSON(true);
                $nama = $nama ?? ($json['nama'] ?? null);
                $email = $email ?? ($json['email'] ?? null);
                $password = $password ?? ($json['password'] ?? null);
            } catch (\Throwable $e) {}
        }

        $data = [
            'nama' => $nama,
            'email' => $email,
            'password' => password_hash($password ?? '', PASSWORD_DEFAULT)
        ];

        $model = new MRegistrasi();
        $model->save($data);
        return $this->responseHasil(200, true, "Registrasi Berhasil");
    }
}
