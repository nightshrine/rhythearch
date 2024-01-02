<?php

namespace App\Http\Middleware;

use Closure;

class Cors
{
  public function handle($request, Closure $next)
  {
    $response = $next($request);
    $http_origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : "";

    // httpオリジンはhttps://www.google.co.jpならwww.google.co.jp
    // ここで指定しているURLだけを許可する。
    if (strstr($http_origin, 'http://localhost:8000')) {
      $response
        ->header("Access-Control-Allow-Origin", $http_origin)
        ->header('Access-Control-Allow-Methods', 'GET, POST')
        ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With')
        ->header('Access-Control-Allow-Credentials', true);
    }
    return $response;
  }
}