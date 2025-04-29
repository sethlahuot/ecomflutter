<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    use HasFactory;

    protected $fillable = [
        'image',
        'title',
        'slug',
        'meta_description',
        'small_description',
        'email1',
        'email2',
        'phone1',
        'phone2',
        'address',
        'contact_description',
        'map_embed'
    ];

    protected $appends = ['image_url'];

    public function getImageUrlAttribute()
    {
        if ($this->image == "") {
            return "";
        }
        return asset('/uploads/logo/'.$this->image);
    }
} 