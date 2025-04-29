<?php

namespace App\Http\Controllers\admin;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use App\Models\TempImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use Intervention\Image\ImageManager;
use Intervention\Image\Drivers\Gd\Driver;

class SettingsController extends Controller
{
    public function index()
    {
        try {
            $settings = Setting::first();
            if (!$settings) {
                // Create default settings if none exist
                $settings = new Setting();
                $settings->save();
            }
            return response()->json($settings);
        } catch (\Exception $e) {
            Log::error('Error fetching settings: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to fetch settings'], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $settings = Setting::first() ?? new Setting();

            // Handle image upload using temp image
            if ($request->temp_image_id) {
                $tempImage = TempImage::find($request->temp_image_id);
                
                if ($tempImage) {
                    // Delete old image if exists
                    if ($settings->image && file_exists(public_path('uploads/logo/' . $settings->image))) {
                        unlink(public_path('uploads/logo/' . $settings->image));
                    }

                    // Create logo directory if it doesn't exist
                    if (!file_exists(public_path('uploads/logo'))) {
                        mkdir(public_path('uploads/logo'), 0777, true);
                    }

                    // Move and process the image
                    $extArray = explode('.', $tempImage->name);
                    $ext = end($extArray);
                    $imageName = time() . '.' . $ext;

                    // Move the image
                    rename(
                        public_path('uploads/temp/' . $tempImage->name),
                        public_path('uploads/logo/' . $imageName)
                    );

                    // Delete the temp image record
                    $tempImage->delete();

                    $settings->image = $imageName;
                }
            }

            // Update other fields
            $settings->title = $request->title;
            $settings->slug = $request->slug;
            $settings->meta_description = $request->meta_description;
            $settings->small_description = $request->small_description;
            $settings->email1 = $request->email1;
            $settings->email2 = $request->email2;
            $settings->phone1 = $request->phone1;
            $settings->phone2 = $request->phone2;
            $settings->address = $request->address;
            $settings->contact_description = $request->contact_description;
            $settings->map_embed = $request->map_embed;

            $settings->save();

            return response()->json([
                'message' => 'Settings saved successfully',
                'settings' => $settings
            ]);
        } catch (\Exception $e) {
            Log::error('Error saving settings: ' . $e->getMessage());
            return response()->json([
                'message' => 'Error saving settings: ' . $e->getMessage()
            ], 500);
        }
    }
} 