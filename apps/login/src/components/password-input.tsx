"use client";

import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import { forwardRef, useState } from "react";
import { TextInput, TextInputProps } from "./input";

export type PasswordInputProps = Omit<TextInputProps, "type"> & {
  autoComplete?: string;
};

// eslint-disable-next-line react/display-name
export const PasswordInput = forwardRef<HTMLInputElement, PasswordInputProps>((props, ref) => {
  const [showPassword, setShowPassword] = useState(false);

  return (
    <div className="relative">
      <TextInput {...props} ref={ref} type={showPassword ? "text" : "password"} />
      <button
        type="button"
        onClick={() => setShowPassword(!showPassword)}
        className="absolute right-2 top-[20px] text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-200 transition-colors"
        aria-label={showPassword ? "Hide password" : "Show password"}
        tabIndex={-1}
      >
        {showPassword ? (
          <EyeSlashIcon className="h-5 w-5" />
        ) : (
          <EyeIcon className="h-5 w-5" />
        )}
      </button>
    </div>
  );
});
