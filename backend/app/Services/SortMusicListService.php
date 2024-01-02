<?php

namespace App\Services;

use Illuminate\Support\Facades\Log;

class sortMusicListService
{
    // 巨大な数 初期値
    private const INF = 1000000007;
    // 最大検索曲数
    private const MAX_SEARCH_MUSIC_NUM = 30;
    // 誤差が少ない順にソートされた音楽リストを返す
    public function rhythmDiffSortService($data_rhythms, $user_rhythm)
    {
        // 誤差のデータが含まれる配列
        $rhythms_diff_list = [];
        foreach ($data_rhythms as $rhythm) {
            // 誤差を計算
            $rhythms_diff = $this->rhythmDiff(json_decode($rhythm['rhythm']), $user_rhythm);
            array_push($rhythms_diff_list, [
                'rhythm_diff' => $rhythms_diff,
                'title' => $rhythm['title'],
                'artist' => $rhythm['artist'],
            ]);
        }
        // 誤差が少ない順にソート
        $rhythms_diffs = array_column($rhythms_diff_list, 'rhythm_diff');
        array_multisort($rhythms_diffs, SORT_ASC, $rhythms_diff_list);

        // 最大検索曲数までに絞る
        $rhythms_diff_list = array_slice($rhythms_diff_list, 0, self::MAX_SEARCH_MUSIC_NUM);

        return $rhythms_diff_list;
    }

    private function rhythmDiff($data_rhythm, $user_rhythm)
    {
        // 長い方をlong_rhythm, 短い方をshort_rhythmとする
        $long_rhythm = $data_rhythm;
        $short_rhythm = $user_rhythm;
        if (count($long_rhythm) < count($short_rhythm)) {
            $long_rhythm = $user_rhythm;
            $short_rhythm = $data_rhythm;
        }

        $long_rhythm_length = count($long_rhythm);
        $short_rhythm_length = count($short_rhythm);
        $rhythm_diff = self::INF;
        for ($i = 0; $i < $long_rhythm_length - $short_rhythm_length + 1; $i++) {
            // $iから始まる長さがshort_rhythm_lengthのリズムとの誤差を計算
            $rhythm_diff = min($rhythm_diff, $this->listdiff($long_rhythm, $short_rhythm, $i));
        }

        return $rhythm_diff;
    }

    private function listDiff($long_rhythm, $short_rhythm, $start_index)
    {
        $list_diff = 0;
        for ($i = 0; $i < count($short_rhythm); $i++) {
            $list_diff += abs($long_rhythm[$start_index + $i] - $short_rhythm[$i]);
        }
        return $list_diff;
    }
}
