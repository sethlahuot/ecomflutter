<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('settings', function (Blueprint $table) {
            $table->id();
            $table->string('image')->nullable();
            $table->string('title')->nullable();
            $table->string('slug')->nullable();
            $table->text('meta_description')->nullable();
            $table->text('small_description')->nullable();
            $table->string('email1')->nullable();
            $table->string('email2')->nullable();
            $table->string('phone1')->nullable();
            $table->string('phone2')->nullable();
            $table->text('address')->nullable();
            $table->text('contact_description')->nullable();
            $table->text('map_embed')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('settings');
    }
}; 