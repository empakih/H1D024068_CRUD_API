<?php

namespace App\Controllers;

use App\Models\MProduk;

class ProdukController extends RestfulController
{
    private function getField($key)
    {
        $val = $this->request->getVar($key);
        if ($val !== null) {
            return $val;
        }
        try {
            $json = $this->request->getJSON(true);
            return $json[$key] ?? null;
        } catch (\Throwable $e) {
            return null;
        }
    }

    public function create()
    {
        $data = [
            'kode_produk' => $this->getField('kode_produk'),
            'nama_produk' => $this->getField('nama_produk'),
            'harga'       => $this->getField('harga')
        ];

        $model = new MProduk();
        $model->insert($data);
        $produk = $model->find($model->getInsertID());
        return $this->responseHasil(200, true, $produk);
    }

    public function list()
    {
        $model = new MProduk();
        $produk = $model->findAll();
        return $this->responseHasil(200, true, $produk);
    }

    public function detail($id = null)
    {
        $model = new MProduk();
        $produk = $model->find($id);
        return $this->responseHasil(200, true, $produk);
    }

    public function ubah($id = null)
    {
        $data = [
            'kode_produk' => $this->getField('kode_produk'),
            'nama_produk' => $this->getField('nama_produk'),
            'harga'       => $this->getField('harga')
        ];

        $model = new MProduk();
        $model->update($id, $data);
        $produk = $model->find($id);

        return $this->responseHasil(200, true, $produk);
    }

    public function hapus($id = null)
    {
        $model = new MProduk();
        $produk = $model->delete($id);

        return $this->responseHasil(200, true, $produk);
    }
}
