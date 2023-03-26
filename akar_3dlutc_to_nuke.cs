using System.Text.RegularExpressions;
using System.Collections;

namespace ThreeDLUTtoNUKE
{
    public class mainForm : Form
    {
        private void FormatMatrix(string Color, string TextInput)
        {
            if (!string.IsNullOrWhiteSpace(TextInput) && Regex.IsMatch(TextInput, "^(R:)"))
            {
                // collect all colors
                char[] delimiterChars = { ' ', '%', 'R', 'G', 'B', ':' };
                decimal[] MatrixColors = TextInput.Split(delimiterChars, StringSplitOptions.RemoveEmptyEntries).Select(decimal.Parse).ToArray();

                // format all rgb values
                for (int i = 0; i < 3; i++)
                {

                    MatrixColors[i] /= 100;

                    // write values back into input fields
                    ((TextBox)Controls["matrix" + Color + i]).Text = (MatrixColors[i]).ToString();
                }

                // collect values from grid
                Hashtable Matrix = new Hashtable();
                string[] Colors = new string[] { "red", "green", "blue" };

                bool incomplete = true;
                for (int i = 0; i < 3; i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        if (string.IsNullOrWhiteSpace(((TextBox)Controls["matrix" + Colors[i] + j]).Text))
                        {
                            incomplete = true;
                            return;
                        }
                        else
                        {
                            Matrix[Colors[i]] += ((TextBox)Controls["matrix" + Colors[i] + j]).Text + ' ';
                            incomplete = false;
                        }
                    }
                }
                
                // create nuke output
                if (!incomplete)
                {
                    string NukeNode =   "ColorMatrix {\n" +
                                        "inputs 0\n" +
                                        "matrix {\n" +
                                        "{" + (Matrix["red"]).ToString().Trim() + "}\n" +
                                        "{" + (Matrix["green"]).ToString().Trim() + "}\n" +
                                        "{" + (Matrix["blue"]).ToString().Trim() + "}\n" +
                                        "}\n" +
                                        "name ColorMatrix3DLUTCreator\n" +
                                        "selected true\n" +
                                        "xpos 0\n" +
                                        "ypos 0\n" +
                                        "}";

                    Clipboard.SetText(NukeNode);

                    labelstatus.Text = "Status: Nuke Matrix successfully copied to Clipboard.";
                }
            }
        }

        private void FormatCurves()
        {
            if (!string.IsNullOrWhiteSpace(lightroom.Text) && File.Exists(lightroom.Text) && Path.HasExtension(".lrtemplate"))
            {
                string LightroomImport = null;
                // read lightroom template
                try
                {
                    LightroomImport = File.ReadAllText(lightroom.Text);
                }
                catch (IOException)
                {
                    labelstatus.Text = "Status: Failed to read file.";
                }

                if (!string.IsNullOrEmpty(LightroomImport))
                {
                    string LightroomTemplate = null;
                    LightroomTemplate = Regex.Replace(LightroomImport, "\\s+", "");

                    string[] RGB = new string[] { "PV2012", "Blue", "Green", "Red" };
                    Hashtable Curve = new Hashtable();

                    for (int i = 0; i < 4; i++)
                    {
                        Regex regex = new Regex(@"(?s)" + RGB[i] + "={0,(.*?),}");
                        Match match = regex.Match(LightroomTemplate);
                        if (match.Success)
                        {
                            // array is kept as string even it holds decimal values because it needs to be in string format later
                            Curve[RGB[i]] = match.Groups[1].Value.Split(',').ToArray();
                        }
                    }

                    // format all rgb values
                    if (Curve.Contains("PV2012") | Curve.Contains("Red") | Curve.Contains("Green") | Curve.Contains("Blue"))
                    {
                        for (int i = 0; i < 4; i++)
                        {
                            for (int j = 0; j < (Curve[RGB[i]] as string[]).Length; j++)
                            {
                                string X = "x";
                                if (j % 2 == 0) // even test
                                {
                                    X = "";
                                }

                                (Curve[RGB[i]] as string[])[j] = X + (Math.Round(decimal.Parse((Curve[RGB[i]] as string[])[j]) / 255, 6)).ToString();
                            }
                        }

                        // create nuke output
                        string NukeNode =   "ColorLookup {\n" +
                                            "lut {master {}\n" +
                                            "master {curve " + string.Join(' ', Curve["PV2012"] as string[]) + "}\n" +
                                            "red {curve " + string.Join(' ', Curve["Red"] as string[]) + "}\n" +
                                            "green {curve " + string.Join(' ', Curve["Green"] as string[]) + "}\n" +
                                            "blue {curve " + string.Join(' ', Curve["Blue"] as string[]) + "}\n" +
                                            "alpha {}}\n" +
                                            "name ColorLookup3DLUTCreator\n" +
                                            "xpos 0\n" +
                                            "ypos 0\n" +
                                            "}";

                        Clipboard.SetText(NukeNode);

                        labelstatus.Text = "Status: Nuke Curves successfully copied to Clipboard.";
                    
                    }
                    else
                    {
                        labelstatus.Text = "Status: Cannot find the RGB values in the Lightroom Template.";
                    }
                }
            }
            else
            {
                labelstatus.Text = "Status: Input is not valid.";
            }
        }

        private Button button;
        private void button_Click(object sender, EventArgs e)  
        {
            OpenFileDialog openFileDialog = new OpenFileDialog()
            {  
                // InitialDirectory = @"C:\Work\scripts\nuke\3dlut2nuke\",
                Title = "Select your Lightroom Template",
                DefaultExt = "lrtemplate",
                Filter = "Lightroom|*.lrtemplate",
                RestoreDirectory = true
            };

            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {
                lightroom.Text = openFileDialog.FileName;
            }
        }

        private Panel divider1;
        private Panel divider2;

        private CheckBox checkboxOnTop;
        private void checkboxOnTop_CheckStateChanged(object sender, EventArgs e)  
        {  
            TopMost = checkboxOnTop.Checked;
        }

        private Label labelcurves;
        private Label labelmatrix;
        private Label labelstatus;
        private Label labelinfo;

        private TextBox lightroom;
        private void lightroom_DragOver(object sender, DragEventArgs e)
        {
            if (!e.Data.GetDataPresent(DataFormats.FileDrop))
            {
                e.Effect = DragDropEffects.None;
                lightroom.Text = "Not a File!";
                return;
            }
            else
            {
                e.Effect = DragDropEffects.Copy;
            }
        }

        private void lightroom_DragDrop(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
            {
                string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);
                if(files != null && files[0].Length != 0)
                {
                    lightroom.Text = files[0];
                }
            }
        }

        private void lightroom_TextChanged(object sender, EventArgs e)  
        {  
            FormatCurves();
        }

        private TextBox matrixred0;
        private void matrixred0_TextChanged(object sender, EventArgs e)  
        {  
            FormatMatrix("red", matrixred0.Text);
        }
        private TextBox matrixred1;
        private TextBox matrixred2;

        private TextBox matrixgreen0;
        private void matrixgreen0_TextChanged(object sender, EventArgs e)  
        {  
            FormatMatrix("green", matrixgreen0.Text);
        }
        private TextBox matrixgreen1;
        private TextBox matrixgreen2;

        private TextBox matrixblue0;
        private void matrixblue0_TextChanged(object sender, EventArgs e)  
        {  
            FormatMatrix("blue", matrixblue0.Text);
        }
        private TextBox matrixblue1;
        private TextBox matrixblue2;

        [STAThread]
        static void Main() 
        {
            Application.EnableVisualStyles();
            Application.Run(new mainForm());
        }

        public mainForm()
        {
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(650, 195);
            FormBorderStyle = FormBorderStyle.FixedDialog;
            StartPosition = FormStartPosition.CenterScreen;
            Text = "akar \\\\ 3D LUT Creator to NUKE v1.0.4";
            MaximizeBox = false;
            MinimizeBox = true;
            TopMost = true;

            button = new Button()
            {
                Location = new Point(570, 14),
                Size = new Size(60, 22),
                FlatStyle = FlatStyle.System,
                Text = "Select",
                TabIndex = 2
            };
            button.Click += new EventHandler(button_Click); 
            Controls.Add(button);

            divider1 = new Panel()
            {
                Location = new Point(15, 47),
                Size = new Size(614, 1),
                BackColor = Color.FromArgb(217, 217, 217),
                BorderStyle = BorderStyle.None
            };
            Controls.Add(divider1);

            divider2 = new Panel()
            {
                Location = new Point(15, 143),
                Size = new Size(614, 1),
                BackColor = Color.FromArgb(217, 217, 217),
                BorderStyle = BorderStyle.None
            };
            Controls.Add(divider2);

            checkboxOnTop = new CheckBox()
            {
                Location = new Point(510, 159),
                Size = new Size(120, 20),
                Text = "Always on top",
                Checked = true,
                RightToLeft = RightToLeft.Yes,
                TabIndex = 6
            };
            checkboxOnTop.CheckStateChanged += new EventHandler(checkboxOnTop_CheckStateChanged); 
            Controls.Add(checkboxOnTop);

            labelcurves = new Label()
            {
                Location = new Point(12, 18),
                Size = new Size(50, 22),
                Text = "Curves:"
            };
            Controls.Add(labelcurves);

            labelmatrix = new Label()
            {
                Location = new Point(12, 64),
                Size = new Size(50, 22),
                Text = "Matrix:"
            };
            Controls.Add(labelmatrix);

            labelstatus = new Label()
            {
                Location = new Point(12, 160),
                Size = new Size(50, 22),
                AutoSize = true,
                Text = "Status:"
            };
            Controls.Add(labelstatus);

            labelinfo = new Label() {
                Location = new Point(68, 160),
                Size = new Size(250, 22),
                Text = ""
            };
            Controls.Add(labelinfo);

            lightroom = new TextBox()
            {
                Location = new Point(68, 15),
                Size = new Size(487, 22),
                Text = "",
                TabIndex = 1,
                AllowDrop = true
            };
            lightroom.DragOver += new DragEventHandler(lightroom_DragOver);
            lightroom.DragDrop += new DragEventHandler(lightroom_DragDrop); 
            lightroom.TextChanged += new EventHandler(lightroom_TextChanged); 
            Controls.Add(lightroom);

            matrixred0 = new TextBox()
            {
                Location = new Point(68, 61),
                Size = new Size(50, 22),
                Text = "",
                TabIndex = 3,
                Name = "matrixred0"
            };
            matrixred0.TextChanged += new EventHandler(matrixred0_TextChanged); 
            Controls.Add(matrixred0);

            matrixred1 = new TextBox()
            {
                Location = new Point(128, 61),
                Size = new Size(50, 22),
                Text = "",
                Enabled = false,
                Name = "matrixred1"
            };
            Controls.Add(matrixred1);

            matrixred2 = new TextBox()
            {
                Location = new Point(188, 61),
                Size = new Size(50, 22),
                Text = "",
                Enabled = false,
                Name = "matrixred2"
            };
            Controls.Add(matrixred2);

            matrixgreen0 = new TextBox()
            {
                Location = new Point(68, 86),
                Size = new Size(50, 22),
                Text = "",
                TabIndex = 4,
                Name = "matrixgreen0"
            };
            matrixgreen0.TextChanged += new EventHandler(matrixgreen0_TextChanged); 
            Controls.Add(matrixgreen0);

            matrixgreen1 = new TextBox()
            {
                Location = new Point(128, 86),
                Size = new Size(50, 22),
                Text = "",
                Enabled = false,
                Name = "matrixgreen1"
            };
            Controls.Add(matrixgreen1);

            matrixgreen2 = new TextBox()
            {
                Location = new Point(188, 86),
                Size = new Size(50, 22),
                Text = "",
                Enabled = false,
                Name = "matrixgreen2"
            };
            Controls.Add(matrixgreen2);

            matrixblue0 = new TextBox()
            {
                Location = new Point(68, 111),
                Size = new Size(50, 22),
                Text = "",
                TabIndex = 5,
                Name = "matrixblue0"
            };
            matrixblue0.TextChanged += new EventHandler(matrixblue0_TextChanged); 
            Controls.Add(matrixblue0);

            matrixblue1 = new TextBox()
            {
                Location = new Point(128, 111),
                Size = new Size(50, 22),
                Text = "",
                Enabled = false,
                Name = "matrixblue1"
            };
            Controls.Add(matrixblue1);

            matrixblue2 = new TextBox()
            {
                Location = new Point(188, 111),
                Size = new Size(50, 22),
                Text = "",
                Enabled = false,
                Name = "matrixblue2"
            };
            Controls.Add(matrixblue2);
        }
    }
}