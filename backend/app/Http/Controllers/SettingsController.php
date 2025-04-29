<?php

namespace App\Http\Controllers\admin;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

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

            // Handle image upload
            if ($request->hasFile('image')) {
                // Delete old image if exists
                if ($settings->image && Storage::exists('public/uploads/' . $settings->image)) {
                    Storage::delete('public/uploads/' . $settings->image);
                }

                $image = $request->file('image');
                $imageName = time() . '.' . $image->getClientOriginalExtension();
                $image->storeAs('public/uploads', $imageName);
                $settings->image = $imageName;
            }

            // Update other fields
            $settings->title = $request->title;
            $settings->slug = $request->slug;
            $settings->meta_description = $request->meta_description;
            $settings->small_description = $request->small_description;
            $settings->about_description1 = $request->about_description1;
            $settings->about_description2 = $request->about_description2;
            $settings->about_description3 = $request->about_description3;
            $settings->about_description4 = $request->about_description4;
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