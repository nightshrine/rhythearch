<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RhythmsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $rhythms = [
            [
                'rhythm' => '[52, 774, 2982, 235]',
                'title' => 'test1',
                'artist' => 'test1',
                'voice_type' => 'test1',
                'category' => 'test1',
                'sound_type' => 'test1',
            ]
        ];

        foreach ($rhythms as $rhythm) {
            \App\Models\Rhythm::create($rhythm);
        }
    }
}