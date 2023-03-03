<?php

namespace Bookme\Admin\Component\API;

class API
{
    public function callAPILogin($data)
    {
        $curl = curl_init('https://api.bookme.local.com/users/login/');
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HEADER, false);
        curl_setopt($curl, CURLOPT_HTTPHEADER, ['apikey: ' . getenv("APIKEY")]);
        curl_setopt($curl, CURLOPT_POST, true);
       
        $dataJson = json_encode($data);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $dataJson);
        $output = curl_exec($curl);
        if ($output === false) {
            trigger_error('Erreur curl : ' . curl_error($curl), E_USER_WARNING);
        } else {
            return $output;
        }
        curl_close($curl);
    }

    public function callAPIGet($entity)
    {
        $curl = curl_init('https://api.bookme.local.com/' . $entity);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $data = curl_exec($curl);
        if ($data === false) {
            var_dump(curl_error($curl));
        }
        curl_close($curl);
        return $data;
    }

    public function callAPIGetById($entity, $id)
    {
        $curl = curl_init('https://api.bookme.local.com/' . $entity . '/' . $id);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $data = curl_exec($curl);
        if ($data === false) {
            var_dump(curl_error($curl));
        }
        curl_close($curl);
        return $data;
    }

    public function callAPIPost($data, $entity)
    {
        $curl = curl_init('https://api.bookme.local.com/' . $entity);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HEADER, false);
        curl_setopt($curl, CURLOPT_POST, true);
        // var_dump($curl);
        
        $dataJson = json_encode($data);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $dataJson);
        $output = curl_exec($curl);
        if ($output === false) {
            trigger_error('Erreur curl : ' . curl_error($curl), E_USER_WARNING);
        } else {
            return $output;
        }
        curl_close($curl);
    }

    public function callAPIPatch($data, $entity, $id)
    {
        $data_json = json_encode($data);
        $url = 'https://api.bookme.local.com/' . $entity . '/' . $id ;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json', 'Content-Length: ' . strlen($data_json)));
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PATCH');
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data_json);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $response  = curl_exec($ch);
        curl_close($ch);
    }
}
