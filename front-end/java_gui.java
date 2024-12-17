import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.URL;
import java.net.URI;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Scanner;
import javax.imageio.ImageIO;
import java.util.HashMap;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.Collection;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;

public class java_gui extends JPanel implements MouseListener, MouseMotionListener {
    private final int imageWidth = 29; // Status image width
    private final int imageHeight = 29; // Status image height
    private int rows;
    private int cols;
    private String[][] configMatrix;
    private String currentTime;
    private Integer[] matrixSize;
    private final Timer timer;
    private BufferedImage onImage;
    private BufferedImage onImageE;
    private BufferedImage offImage;
    private BufferedImage offImageE;
    private BufferedImage redImage;
    private BufferedImage greenImage;
    private BufferedImage navyImage;
    private BufferedImage cyanImage;
    private BufferedImage purpleImage;
    private BufferedImage blackImage;
    private int mouseX; // Store the X coordinate
    private int mouseY; // Store the Y coordinate
    // private boolean isCursorOverNode;
    private Color[] colors = {Color.BLUE, Color.ORANGE, Color.MAGENTA, Color.RED, Color.GREEN};
    private String ipAddress;

    public java_gui(String ipAddress) {
        this.ipAddress = ipAddress;
        // Methods calls to get information when passing the cursor over the gui
        addMouseListener(this);
        addMouseMotionListener(this);
        // Load the different matrix from the nodejs server.
        matrixSize = getMatrixSize("http://" + ipAddress + ":8083/matrix_size.txt");
        configMatrix = loadStringMatrixFromService("http://" + ipAddress + ":8083/config_matrix.txt");
        currentTime = loadStringFromService("http://" + ipAddress + ":8083/time_diff.txt");

        cols=matrixSize[1];
        rows=matrixSize[0];

        // Initialize the images
        onImage = loadImage("images/green_dot_20_20.png");
        onImageE = loadImage("images/green_rhombus.png");
        offImage = loadImage("images/red_dot_20_20.png");
        offImageE = loadImage("images/red_rhombus.png");
        redImage = loadImage("images/red.png");
        greenImage = loadImage("images/green.png");
        navyImage = loadImage("images/navy.png");
        cyanImage = loadImage("images/cyan.png");
        purpleImage = loadImage("images/purple.png");
        blackImage = loadImage("images/black.png");


        // Initialize the timer to update the status and colour matrix each second
        timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                configMatrix = loadStringMatrixFromService("http://" + ipAddress + ":8083/config_matrix.txt");
                currentTime = loadStringFromService("http://" + ipAddress + ":8083/time_diff.txt");
                repaint();
            }
        }, 0, 300);
    }
 
    private BufferedImage loadImage(String filename) {
        // Method for load the images
        try {
            URL imageURL = getClass().getResource(filename);
            return ImageIO.read(imageURL);
        } catch (IOException e) {
            e.printStackTrace();
            return new BufferedImage(imageWidth, imageHeight, BufferedImage.TYPE_INT_ARGB);
        }
    }

    private Integer[] getMatrixSize(String nodejsUrl) {
        // Method for creating the matrix variable from file (string)
        try {
            URL url = URI.create(nodejsUrl).toURL();
            Scanner scanner = new Scanner(url.openStream());
            String[][] newMatrix = new String[2][2];
            Integer[] matrixSize = new Integer[2];
            for (int i = 0; i < 2; i++) {
                for (int j = 0; j < 2; j++) {
                    if (scanner.hasNext()) {
                        newMatrix[i][j] = scanner.next();
                    }
                }
            }
            matrixSize[0] = Integer.parseInt(newMatrix[0][1]);
            matrixSize[1] = Integer.parseInt(newMatrix[1][1]);
            return matrixSize;
        } catch (IOException e) {
            e.printStackTrace();
            return new Integer[2]; // Empty matrix in case of error.
        }
    }

    private String[][] loadStringMatrixFromService(String nodejsUrl) {
        // Method for creating the matrix variable from file (string)
        try {
            URL url = URI.create(nodejsUrl).toURL();
            Scanner scanner = new Scanner(url.openStream());
            String[][] newMatrix = new String[rows][cols];
            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < cols; j++) {
                    if (scanner.hasNext()) {
                        newMatrix[i][j] = scanner.next();
                    }
                }
            }
            return newMatrix;
        } catch (IOException e) {
            e.printStackTrace();
            return new String[rows][cols]; // Empty matrix in case of error.
        }
    }

    private String loadStringFromService(String nodejsUrl) {
        try {
            URL url = URI.create(nodejsUrl).toURL();
            Scanner scanner = new Scanner(url.openStream());
    
            if (scanner.hasNext()) {
                return scanner.next();
            } else {
                return "";  // Return an empty string if the file is empty
            }
        } catch (IOException e) {
            e.printStackTrace();
            return ""; // Return an empty string in case of an error.
        }
    }

    // Implement the required methods for MouseListener
    @Override
    public void mouseClicked(MouseEvent e) {
        ;
    }

    @Override
    public void mousePressed(MouseEvent e) {
        ;
    }

    @Override
    public void mouseReleased(MouseEvent e) {
        ;
    }

    @Override
    public void mouseEntered(MouseEvent e) {
        ;
    }

    @Override
    public void mouseExited(MouseEvent e) {
        ;
    }

    // Implement the required methods for MouseMotionListener
    @Override
    public void mouseDragged(MouseEvent e) {
        ;
    }

    @Override
    public void mouseMoved(MouseEvent e) {
        mouseX = e.getX();
        mouseY = e.getY();
        // isCursorOverNode = mouseX >= 0 && mouseY >= 0 && mouseX < onImage.getWidth() && mouseY < onImage.getHeight();
        repaint();
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);

        // Create an ArrayList to store a mix of elements
        HashMap<String, List<List<Integer>>> servicesPoints = new HashMap<>();

        Graphics2D g2d = (Graphics2D)g;

        int width = getWidth();
        int height = getHeight();

        int rows = configMatrix.length;
        int cols = configMatrix[0].length;
        int axisOffset = 20;
        int nodeOffset = 0 + axisOffset;
        int axisY = rows + 1;
        
        //Window background colour
        g.setColor(Color.BLACK);
        g.fillRect(0, 0, width, height);

        // Draw the x-axis
        g.setColor(Color.WHITE);

        // Paint the current time of the simulation
        // g.drawString(currentTime, (cols * imageWidth + nodeOffset + axisOffset + 3)/2, nodeOffset);
        g.drawString(currentTime, (cols * imageWidth)/2, nodeOffset);

        // Paint time string

        
        for (int i = 0; i < rows; i++) {
            // Initialize the axisX here to clear the variable each time the for loop is entered
            int axisX = 0;
            axisY -= 1;
            for (int j = 0; j < cols; j++) {
                axisX += 1;
                // Set the coordinates of each node of the network:
                int x = j * imageWidth + nodeOffset + axisOffset;
                int y = i * imageHeight + nodeOffset;
                // Draw X axis number.
                g.drawString(String.valueOf(axisX), (x + imageWidth / 2) - 3, (rows * imageHeight + nodeOffset * 2) + 15);
                // Draw Y axis number.
                g.drawString(String.valueOf(axisY), axisOffset - 10, (y + imageHeight / 2) + 5);
                // try {
                    // Your existing code that may cause NullPointerException
                    String[] configMatrixSplit = configMatrix[i][j].split(";");
                    String status = configMatrixSplit[0];
                    String domain = configMatrixSplit[1];
                    String colour = configMatrixSplit[2];
                    String service = configMatrixSplit[3];
                    String battery = configMatrixSplit[4];
                    switch (colour) {
                        case "redd":
                            g.drawImage(redImage, x, y, this);
                            break;
                        case "gree":
                            g.drawImage(greenImage, x, y, this);
                            break;
                        case "navy":
                            g.drawImage(navyImage, x, y, this);
                            break;
                        case "cyan":
                            g.drawImage(cyanImage, x, y, this);
                            break;
                        case "purp":
                            g.drawImage(purpleImage, x, y, this);
                            break;
                        case "blac":
                            g.drawImage(blackImage, x, y, this);
                            break;
                        case "noco":
                            break;
                        default:
                            throw new IllegalArgumentException("Invalid colour: " + colour);
                    }
                    switch (status) {
                        case "2":
                            switch (domain) {
                                case "core":
                                    g.drawImage(onImage, x + 5, y + 5, this);
                                    break;
                                case "edge":
                                    g.drawImage(onImageE, x + 5, y + 5, this);
                                    break;
                                case "eedg":
                                    g.drawImage(onImage, x + 5, y + 5, this);
                                    break;
                            }
                            break;
                        case "1":
                            switch (domain) {
                                case "core":
                                    g.drawImage(offImage, x + 5, y + 5, this);
                                    break;
                                case "edge":
                                    g.drawImage(offImageE, x + 5, y + 5, this);
                                    break;
                                case "eedg":
                                    g.drawImage(offImage, x + 5, y + 5, this);
                                    break;
                            }
                            break;
                        case "0":
                            break;
                        default:
                            throw new IllegalArgumentException("Invalid colour: " + colour);
                    }
                    switch (battery) {
                        case "noba":
                            break;
                        default:
                        // int fontSize = 15;
                        // g.setFont(new Font("TimesRoman", Font.PLAIN, fontSize)); 
                        g.drawString(String.valueOf(battery), x + (imageWidth / 4), y + nodeOffset);
                    }
                    if (!service.equals("nose")) {
                        servicesPoints.computeIfAbsent(service, k -> new ArrayList<>()).add(Arrays.asList(x + (imageWidth / 2) , y + (imageHeight / 2)));
                    }
            }
        }
        // Store the different services
        Collection<String> services = servicesPoints.keySet();
        // Iterate over the different services
        int k = 0;
        for (String diffServices : services) {
            // Get only the values for a certain service
            List<List<Integer>> serviceValues = servicesPoints.get(diffServices);
            // Define the variables for the starting and end point to paint the service line.
            List<Integer> prevPair = null;
            List<Integer> currPair = null;
            int i = 0;
            // Check if the iterator has reached the end of available colors. In that case
            // it starts again from the first available colors to continue painting the services lines.
            if (k == colors.length) {
                k = 0;
            }
            // Set the line width
            int lineWidth = 20;
            int ovalWidth = 4;
            g.setColor(colors[k]);
            for (List<Integer> pairValues : serviceValues) {
                if (i == 0) {
                    prevPair = pairValues;
                } else {
                    currPair = pairValues;
                    // Set colour for a certain line
                    Color lineColor = new Color(colors[k].getRGB() & 0x00FFFFFF | (85 << 24), true);
                    g.setColor(lineColor);
                    g2d.setStroke(new BasicStroke(lineWidth));
                    g2d.drawLine(prevPair.get(0), prevPair.get(1), currPair.get(0), currPair.get(1));
                    g.setColor(colors[k]);
                    int srvPointWidth = 4;
                    int srvPointHeight = 4;
                    g2d.setStroke(new BasicStroke(ovalWidth));
                    g2d.drawOval(prevPair.get(0) - srvPointWidth / 2, prevPair.get(1) - srvPointHeight / 2, 4, 4);
                    g2d.drawOval(currPair.get(0) - srvPointWidth / 2, currPair.get(1) - srvPointHeight / 2, 4, 4);
                    prevPair = pairValues;
                }
                i += 1;
                int srvPointWidth = 7;
                int srvPointHeight = 7;
                g2d.fillOval(pairValues.get(0) - srvPointWidth / 2, pairValues.get(1) - srvPointHeight / 2, srvPointWidth, srvPointHeight);
            }
            k += 1;
        }
    }

    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Using default arg 'localhost' for the NodeJS URL.");
        }
        String defaultIpAddress = "localhost"; // Default IP address
        String ipAddress = (args.length > 0) ? args[0] : defaultIpAddress;

        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("Status & Colour Matrix Visualizer");
            java_gui visualizer = new java_gui(ipAddress);
            frame.add(visualizer);
            frame.setSize(500, 500);
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setVisible(true);
        });
    }
}

