<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;

class Rhythm extends Model
{
    use HasFactory;
    protected $guraded = ['id'];

    protected $fillable = [
        'rhythm',
        'title',
        'artist',
        'voice_type',
        'category',
        'sound_type',
    ];

    // rhythmのデータ形式：int[]
    public static $rules = [
        'rhythm' => 'required',
        'title' => 'required | max:200',
        'artist' => 'required | max:200',
        'voice_type' => 'required | max:50',
        'category' => 'required | max:50',
        'sound_type' => 'required | max:50',
    ];

    public function getTargetMusic($conditions)
    {
        // 不明の項目も検索対象に含める
        $conditionsAndHumei = [];
        foreach ($conditions as $key => $value) {
            $conditionAndHumei = [
                [$key, '=', $value],
                [$key, '=', '不明'],
            ];
            $conditionsAndHumei = array_merge($conditionsAndHumei, $conditionAndHumei);
        }
        $rhythms = $this->where($conditions)->get();
        return $rhythms;
    }
}
