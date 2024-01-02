<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRhythmsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('rhythms', function (Blueprint $table) {
            $table->id('id');
            $table->json('rhythm')->nullable();
            $table->string('title')->nullable();
            $table->string('artist')->nullable();
            $table->string('voice_type')->nullable();
            $table->string('category')->nullable();
            $table->string('sound_type')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('rhythms');
    }
}
