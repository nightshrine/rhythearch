<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Rhythm;
use App\Services\sortMusicListService;
use Illuminate\Support\Facades\Log;

class RhythmController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function get_music_list(Request $request)
    {
        $rhythm = array_values($request->rhythm);
        $voice_type = $request->voice_type;
        $category = $request->category;
        $sound_type = $request->sound_type;
        $conditions = [];
        if ($voice_type !== "不明") {
            $conditions['voice_type'] = $voice_type;
        }
        if ($category !== "不明") {
            $conditions['category'] = $category;
        }
        if ($sound_type !== "不明") {
            $conditions['sound_type'] = $sound_type;
        }
        // 検索対象の音楽を取得
        $Rhythm = new Rhythm();
        $rhythms = $Rhythm->getTargetMusic($conditions);

        // 類似度によるソート
        $sortMusicListService = new sortMusicListService();
        $rhythms = $sortMusicListService->rhythmDiffSortService($rhythms, $rhythm);

        return response()->json($rhythms);
    }

    /**
     * Store a newly created resource in storage.
     * @param Request $request
     */
    public function store(Request $request): void
    {
        $rhythm_input = [
            'rhythm' => json_encode($request->rhythm),
            'title' => $request->title,
            'artist' => $request->artist,
            'voice_type' => $request->voice_type,
            'category' => $request->category,
            'sound_type' => $request->sound_type,
        ];

        $Rhythm = new Rhythm();
        $Rhythm->fill($rhythm_input)->save();
    }
}